module CSDL

  # {BooleanProcessor} is a class that can take a tree of AST::Node objects built with {Builder}
  # and produce its boolean expression representation.
  #
  # @example
  #   # Generate your CSDL nodes using the Builder
  #   root_node = CSDL::Builder.new.logical_group(:or) do
  #     #...
  #     condition("fb.content", :contains, "match this string")
  #     #...
  #   end
  #
  #   # Process the root node and its children calling the instance method #process
  #   processor = CSDL::BooleanProcessor.new
  #   expression = processor.process(root_node)
  #   conditions = processor.conditions
  #
  # @see Builder
  # @see http://www.rubydoc.info/gems/ast/AST/Processor AST::Processor
  # @see http://www.rubydoc.info/gems/ast/AST/Node AST::Node
  # @see http://dev.datasift.com/docs/csdl DataSift CSDL Language Documentation
  #
  class BooleanProcessor < ::AST::Processor
    def conditions
      @conditions ||= {}
    end

    def conditions_origins
      @conditions_origins ||= {}
    end

    # AND two or more child nodes together.
    #
    # @example
    #   node = s(:and,
    #            s(:condition,
    #              s(:target, "fb.content"),
    #              s(:operator, :contains")
    #              s(:argument,
    #                s(:string, "foo"))),
    #            s(:condition,
    #              s(:target, "fb.content"),
    #              s(:operator, :contains")
    #              s(:argument,
    #                s(:string, "bar"))))
    #   CSDL::BooleanProcessor.new.process(node)
    #
    # @param node [AST::Node] The :and node to be processed.
    #
    # @raise [MissingChildNodesError] When less than 2 child nodes are present.
    # @raise [InvalidChildNodeError] When it has a child that is neither a condition nor a logical expression.
    #
    # @return [String] Processed child nodes ANDed together into a boolean expression representation.
    #
    def on_and(node)
      logically_join_nodes("And", node.children)
    end

    # Process the first child node as the "argument" in a condition node tree (target + operator + argument).
    #
    # @example
    #   node = s(:argument,
    #            s(:string, "foo"))
    #   CSDL::BooleanProcessor.new.process(node) # => 'foo'
    #
    # @param node [AST::Node] The :argument node to be processed.
    #
    # @return [String] The first child node, processed by its node type into a boolean expression tree representation.
    #
    # @todo Raise if the node doesn't have any children.
    #
    def on_argument(node)
      process(node.children.first).to_s
    end

    # Process :condition node and it's expected children :target, :operator, and :argument nodes. The conditions with "contains_any" and "contains_all" operators are translated into groups of conditions with "contains" operator.
    #
    # @example
    #   node = s(:condition,
    #             s(:target, "fb.content"),
    #             s(:operator, :contains_any),
    #             s(:argument,
    #               s(:string, "foo")))
    #   CSDL::BooleanProcessor.new.process(node) # => "v1"
    #
    # @param node [AST::Node] The :condition node to be processed.
    #
    # @return [String] The child nodes :target, :operator, and :argument, processed and joined into the condition which name is returned.
    #
    # @todo Raise when we don't have a target node.
    # @todo Raise when we don't have a operator node.
    # @todo Raise when we don't have a argument node, assuming the operator is binary.
    # @todo Raise if the argument node's child is not of a valid node type for the given operator.
    #
    def on_condition(node)
      target   = node.children.find { |child| child.type == :target }
      operator = node.children.find { |child| child.type == :operator }
      argument = node.children.find { |child| child.type == :argument }

      if operator and operator.children.first
        operator_name = operator.children.first.to_sym
        if [:contains_any, :contains_all].include? operator_name
          words = argument.children.first.children.first.to_s.split(/(?<!\\),/).map { |value| value.gsub(/(?<!\\)\\,/, ",").strip  }
          conditions = words.map { |word| AST::Node.new(:condition, [target, AST::Node.new(:operator, [:contains]), argument.updated(nil, [AST::Node.new(:string, [word])])]) }
          processed_conditions = process_all(conditions)
          if processed_conditions.count > 1
            group_operator = (operator_name == :contains_any ? :Or : :And)
            return "#{group_operator}(#{processed_conditions.join(",")})"
          else
            return processed_conditions.first
          end
        end
      end
      processed = process_all([ target, operator, argument ])
      condition = processed.compact.join(" ")
      register_condition(condition, node)
    end

    # Process first child node.
    #
    # @example
    #   node = s(:logical_group,
    #            s(:or,
    #             s(:condition,
    #               s(:target, "fb.content"),
    #               s(:operator, :contains")
    #               s(:argument,
    #                 s(:string, "foo"))),
    #             s(:condition,
    #               s(:target, "fb.content"),
    #               s(:operator, :contains")
    #               s(:argument,
    #                 s(:string, "bar")))))
    #   CSDL::BooleanProcessor.new.process(node) # => "Or(v1,v2)"
    #
    # @param node [AST::Node] The :logical_group node to be processed.
    #
    # @raise [MissingChildNodesError] When the node doesn't have a child node.
    # @raise [InvalidChildNodeError] When it has a child that is neither a condition nor a logical expression.
    #
    # @return [String] The first child node processed by its node type into a boolean expression.
    #
    def on_logical_group(node)
      fail MissingChildNodesError, "#{node} should have one child" if node.children.size == 0
      validate_expression_node!(node.children.first, node)
      process(node.children.first)
    end

    # Process :not node as a :condition node, wrapping into the logical operator NOT.
    #
    # @example
    #   node = s(:not,
    #             s(:target, "fb.content"),
    #             s(:operator, :contains_any),
    #             s(:argument,
    #               s(:string, "foo")))
    #   CSDL::BooleanProcessor.new.process(node)
    #
    # @example Negating logical groupings
    #   node = s(:not,
    #            s(:logical_group,
    #              s(:condition,
    #                s(:target, "fb.content"),
    #                s(:operator, :contains_any),
    #                s(:argument,
    #                  s(:string, "baz")))))
    #   CSDL::BooleanProcessor.new.process(node) # => "Not(v1)"
    #
    # @param node [AST::Node] The :not node to be processed.
    #
    # @return [String] The child nodes :target, :operator, and :argument, processed and joined to form the condition which name will be wrapped into Not().
    #
    # @todo Raise when we don't have a target node.
    # @todo Raise when we don't have a operator node.
    # @todo Raise when we don't have a argument node, assuming the operator is binary.
    # @todo Raise if the argument node's child is not of a valid node type for the given operator.
    #
    def on_not(node)
      if node.children.size > 0 && node.children.first.type != :target
        "Not(#{process(node.children.first)})"
      else
        "Not(#{process(node.updated(:condition))})"
      end
    end

    # Process :operator nodes, ensuring the the given terminator value is a valid operator.
    #
    # @example
    #   node = s(:operator, :contains)
    #   CSDL::BooleanProcessor.new.process(node) # => 'contains'
    #
    # @param node [AST::Node] The :operator node to be processed.
    #
    # @return [String] The first child, stringified.
    #
    # @raise [UnknownOperatorError] When the terminator value is not a valid operator. See {CSDL.operator?}.
    #
    def on_operator(node)
      Processor.new.on_operator(node)
    end

    # OR two or more child nodes together.
    #
    # @example
    #   node = s(:or,
    #            s(:condition,
    #              s(:target, "fb.content"),
    #              s(:operator, :contains),
    #              s(:argument,
    #                s(:string, "foo"))),
    #            s(:condition,
    #              s(:target, "fb.content"),
    #              s(:operator, :contains),
    #              s(:argument,
    #                s(:string, "bar"))))
    #   CSDL::BooleanProcessor.new.process(node) # => "Or(v1,v2)"
    #
    # @param node [AST::Node] The :or node to be processed.
    #
    # @raise [MissingChildNodesError] When less than 2 child nodes are present.
    # @raise [InvalidChildNodeError] When it has a child that is neither a condition nor a logical expression.
    #
    # @return [String] Processed child nodes OR'd together into a boolean expression.
    #
    def on_or(node)
      logically_join_nodes("Or", node.children)
    end

    # Process :raw nodes.
    #
    # @example
    #   node = s(:raw, %q{fb.content contains_any "foo" OR fb.parent.content contains_any "foo"})
    #   CSDL::Processor.new.process(node) # => 'v1'
    #
    # @param node [AST::Node] The :raw node to be processed.
    #
    # @return [String] The first child node as an exprvar node.
    #
    # @todo Raise if the node doesn't have any children.
    #
    def on_raw(node)
      condition = node.children.first.to_s
      register_condition(condition, node)
    end

    # Process the first child node. Useful for grouping child nodes without any syntax introduction.
    #
    # @see InteractionFilterProcessor#_return
    # @see InteractionFilterProcessor#tag
    # @see InteractionFilterProcessor#tag_tree
    #
    def on_root(node)
      process(node.children.first) || ""
    end

    # Wrap the stringified terminal value in quotes.
    #
    # @example
    #   node = s(:string, "foo")
    #   CSDL::BooleanProcessor.new.process(node) # => '"foo"'
    #
    # @param node [AST::Node] The :string node to be processed.
    #
    # @return [String] The first child node, processed by its node type into a raw CSDL string representation.
    #
    # @todo Raise if the node doesn't have any children.
    #
    def on_string(node)
      Processor.new.on_string(node)
    end

    # Process :target nodes, ensuring the the given terminator value is a valid operator.
    #
    # @example
    #   node = s(:target, "fb.content")
    #   CSDL::BooleanProcessor.new.process(node) # => 'fb.content'
    #
    # @param node [AST::Node] The :target node to be processed.
    #
    # @return [String] The first child, stringified.
    #
    # @raise [UnknownTargetError] When the terminator value is not a valid operator. See {#validate_target!}.
    #
    # @see #validate_target!
    #
    def on_target(node)
      Processor.new.on_target(node)
    end

    # Raises an {UnknownTargetError} if the target isn't a valid CSDL target. Useful for implenting a
    # child processor that can ensure the target is known and valid for a given use-case
    # (e.g. {InteractionFilterProcessor Interaction Filters} vs {QueryFilterProcessor Query Filters}).
    # Generally not useful to be called directly, use {CSDL.target?} instead.
    #
    # @example
    #   CSDL::Processor.new.validate_target!("fake") # => raises UnknownTargetError
    #
    # @param target_key [String] The target to validate.
    #
    # @return [void]
    #
    # @raise [UnknownTargetError] When the terminator value is not a valid operator. See {CSDL.operator?}.
    #
    def validate_target!(target_key)
      Processor.new.validate_target!(target_key)
    end

    private

    def logically_join_nodes(logical_operator, child_nodes)
      if child_nodes.size < 2
        fail ::CSDL::MissingChildNodesError, ":#{logical_operator} nodes must contain at least two child nodes. Expected >= 2, got #{child_nodes.size}"
      end

      processed_nodes = child_nodes.map do |node|
        validate_expression_node!(node, logical_operator)
        process(node)
      end

      "#{logical_operator}(#{processed_nodes.join(",")})"
    end

    def register_condition(condition, condition_node)
      @conditions ||= {}
      @conditions_origins ||= {}
      @conditions_counter ||= 0
      var_name = @conditions[condition] ||= "v#{(@conditions_counter += 1)}"
      @conditions_origins[var_name] = condition_node.clone
      var_name
    end

    def validate_expression_node!(node, parent_node)
      fail ::CSDL::InvalidChildNodeError, ":#{parent_node} cannot have #{node} as a child" \
        if [:string, :argument, :target, :operator].include?(node.type)
    end
  end
end
