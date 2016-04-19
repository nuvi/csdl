module CSDL

  # {Processor} is a class that can take a tree of AST::Node objects built with {Builder}
  # and produce a valid CSDL string representation according to DataSift's CSDL specification.
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
  #   CSDL::Processor.new.process(root_node)
  #
  # @see Builder
  # @see http://www.rubydoc.info/gems/ast/AST/Processor AST::Processor
  # @see http://www.rubydoc.info/gems/ast/AST/Node AST::Node
  # @see http://dev.datasift.com/docs/csdl DataSift CSDL Language Documentation
  #
  class Processor < ::AST::Processor

    # AND two or more child nodes together.
    #
    # @example
    #   node = s(:and,
    #            s(:string, "foo"),
    #            s(:string, "bar"),
    #            s(:string, "baz"))
    #   CSDL::Processor.new.process(node) # => '"foo" AND "bar" AND "baz"'
    #
    # @param node [AST::Node] The :and node to be processed.
    #
    # @raise [MissingChildNodesError] When less than 2 child nodes are present.
    #
    # @return [String] Processed child nodes ANDed together into a raw CSDL string representation.
    #
    def on_and(node)
      logically_join_nodes("AND", node.children)
    end

    # Process the first child node as the "argument" in a condition node tree (target + operator + argument).
    #
    # @example
    #   node = s(:argument,
    #            s(:string, "foo"))
    #   CSDL::Processor.new.process(node) # => '"foo"'
    #
    # @param node [AST::Node] The :argument node to be processed.
    #
    # @return [String] The first child node, processed by its node type into a raw CSDL string representation.
    #
    # @todo Raise if the node doesn't have any children.
    #
    def on_argument(node)
      process(node.children.first)
    end

    # Process :condition node and it's expected children :target, :operator, and :argument nodes.
    #
    # @example
    #   node = s(:condition,
    #             s(:target, "fb.content"),
    #             s(:operator, :contains_any),
    #             s(:argument,
    #               s(:string, "foo")))
    #   CSDL::Processor.new.process(node) # => 'fb.content contains_any "foo"'
    #
    # @param node [AST::Node] The :condition node to be processed.
    #
    # @return [String] The child nodes :target, :operator, and :argument, processed and joined.
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
      process_all([ target, operator, argument ].compact).join(" ")
    end

    # Wrap all processed child nodes in parentheses.
    #
    # @example
    #   node = s(:logical_group,
    #            s(:or,
    #             s(:string, "foo"),
    #             s(:string, "bar"),
    #             s(:string, "baz")))
    #   CSDL::Processor.new.process(node) # => '("foo" OR "bar" OR "baz")'
    #
    # @param node [AST::Node] The :logical_group node to be processed.
    #
    # @return [String] All child nodes processed by their node types into a raw CSDL string representation, wrapped in parentheses.
    #
    def on_logical_group(node)
      "(" + process_all(node.children).join(" ") + ")"
    end

    # Process :not node as a :condition node, prepending the logical operator NOT to the processed :condition node.
    #
    # @example
    #   node = s(:not,
    #             s(:target, "fb.content"),
    #             s(:operator, :contains_any),
    #             s(:argument,
    #               s(:string, "foo")))
    #   CSDL::Processor.new.process(node) # => 'NOT fb.content contains_any "foo"'
    #
    # @example Negating logical groupings
    #   node = s(:not,
    #            s(:logical_group,
    #              s(:condition,
    #                s(:target, "fb.content"),
    #                s(:operator, :contains_any),
    #                s(:argument,
    #                  s(:string, "baz")))))
    #   CSDL::Processor.new.process(node) # => 'NOT (fb.content contains_any "baz")'
    #
    # @param node [AST::Node] The :not node to be processed.
    #
    # @return [String] The child nodes :target, :operator, and :argument, processed and joined.
    #
    # @todo Raise when we don't have a target node.
    # @todo Raise when we don't have a operator node.
    # @todo Raise when we don't have a argument node, assuming the operator is binary.
    # @todo Raise if the argument node's child is not of a valid node type for the given operator.
    #
    def on_not(node)
      if node.children.size > 0 && node.children.first.type != :target
        "NOT " + process(node.children.first)
      else
        "NOT " + process(node.updated(:condition))
      end
    end

    # Process :operator nodes, ensuring the the given terminator value is a valid operator.
    #
    # @example
    #   node = s(:operator, :contains)
    #   CSDL::Processor.new.process(node) # => 'contains'
    #
    # @param node [AST::Node] The :operator node to be processed.
    #
    # @return [String] The first child, stringified.
    #
    # @raise [UnknownOperatorError] When the terminator value is not a valid operator. See {CSDL.operator?}.
    #
    def on_operator(node)
      operator = node.children.first.to_s
      unless ::CSDL.operator?(operator)
        fail ::CSDL::UnknownOperatorError, "Operator #{operator} is unknown"
      end
      operator
    end

    # OR two or more child nodes together.
    #
    # @example
    #   node = s(:or,
    #             s(:string, "foo"),
    #             s(:string, "bar"),
    #             s(:string, "baz"))
    #   CSDL::Processor.new.process(node) # => '"foo" OR "bar" OR "baz"'
    #
    # @param node [AST::Node] The :or node to be processed.
    #
    # @raise [MissingChildNodesError] When less than 2 child nodes are present.
    #
    # @return [String] Processed child nodes OR'd together into a raw CSDL string representation.
    #
    def on_or(node)
      logically_join_nodes("OR", node.children)
    end

    # Process :raw nodes.
    #
    # @example
    #   node = s(:raw, %q{fb.content contains_any "foo" OR fb.parent.content contains_any "foo"})
    #   CSDL::Processor.new.process(node) # => 'fb.content contains_any "foo" OR fb.parent.content contains_any "foo"'
    #
    # @param node [AST::Node] The :raw node to be processed.
    #
    # @return [String] The first child node as a string.
    #
    # @todo Raise if the node doesn't have any children.
    #
    def on_raw(node)
      node.children.first.to_s
    end

    # Process all child nodes. Useful for grouping child nodes without any syntax introduction.
    #
    # @see InteractionFilterProcessor#_return
    # @see InteractionFilterProcessor#tag
    # @see InteractionFilterProcessor#tag_tree
    #
    def on_root(node)
      process_all(node.children).join(" ")
    end

    # Wrap the stringified terminal value in quotes.
    #
    # @example
    #   node = s(:string, "foo")
    #   CSDL::Processor.new.process(node) # => '"foo"'
    #
    # @param node [AST::Node] The :string node to be processed.
    #
    # @return [String] The first child node, processed by its node type into a raw CSDL string representation.
    #
    # @todo Raise if the node doesn't have any children.
    #
    def on_string(node)
      '"' + node.children.first.to_s.gsub(/"/, '\"') + '"'
    end

    # Process :target nodes, ensuring the the given terminator value is a valid operator.
    #
    # @example
    #   node = s(:target, "fb.content")
    #   CSDL::Processor.new.process(node) # => 'fb.content'
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
      target = node.children.first.to_s
      validate_target!(target)
      target
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
      unless ::CSDL.target?(target_key)
        fail ::CSDL::UnknownTargetError, "Target '#{target_key}' is not a known target type."
      end
    end

    private

    def logically_join_nodes(logical_operator, child_nodes)
      if child_nodes.size < 2
        fail ::CSDL::MissingChildNodesError, ":#{logical_operator} nodes must contain at least two child nodes. Expected >= 2, got #{child_nodes.size}"
      end

      initial = process(child_nodes.first)
      rest = child_nodes.drop(1)

      rest.reduce(initial) do |csdl, child|
        csdl += " #{logical_operator.upcase} " + process(child)
        csdl
      end
    end

  end
end


