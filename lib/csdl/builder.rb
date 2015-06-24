module CSDL

  # {Builder} is a class used to produce {http://www.rubydoc.info/gems/ast/AST/Node AST::Node} objects built to be processed
  # by any one of {Processor}, {InteractionFilterProcessor}, or {QueryFilterProcessor}.
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
  # @see http://dev.datasift.com/docs/csdl DataSift CSDL Language Documentation
  #
  class Builder
    include ::AST::Sexp

    # Logically AND two or more child nodes together. Does not implicitly create a logical group with parentheses.
    # If you want to logically group the ANDs, see {#logical_group}.
    #
    # @example
    #   nodes = CSDL::Builder.new._and do
    #     [
    #       condition("fb.content", :contains, "this is a string"),
    #       condition("fb.parent.content", :contains, "this is a string"),
    #     ]
    #   end
    #   CSDL::Processor.new.process(nodes) # => 'fb.content contains "this is a string" AND fb.parent.content contains "this is a string"'
    #
    # @param block [Proc] Block to return child nodes to apply to this :and node. Block is evaluated against the builder instance.
    # @yieldreturn [AST::Node, Array<AST::Node>] An AST node or array of AST nodes to be wrapped by an :and node.
    #
    # @return [AST::Node] An AST :and node with its children being the node(s) returned by the block.
    #
    # @see #logical_group
    #
    def _and(&block)
      children = __one_or_more_child_nodes(&block)
      if children.empty?
        nil
      elsif children.size == 1
        children.first
      else
        s(:and, *children)
      end
    end

    # Negate a condition. Analogous to {#condition} with NOT prepended to the condition.
    #
    # @example
    #   node = CSDL::Builder.new._not("fb.content", :contains, "do not match this string")
    #   CSDL::Processor.new.process(node) # => 'NOT fb.content contains "do not match this string"'
    #
    # @example Multiple negations ANDed together
    #   nodes = CSDL::Builder.new._and do
    #     [
    #       _not("fb.content", :contains, "this is a string"),
    #       _not("fb.parent.content", :contains, "this is a string"),
    #     ]
    #   end
    #   CSDL::Processor.new.process(nodes) # => 'NOT fb.content contains "this is a string" AND NOT fb.parent.content contains "this is a string"'
    #
    # @param target [#to_s] A valid Target specifier (see {CSDL::TARGETS}).
    # @param operator [#to_s] A valid Operator specifier (see {CSDL::OPERATORS}).
    # @param argument [String, Numeric, nil] The comparator value, if applicable for the given operator.
    #
    # @return [AST::Node] An AST :not node with child target, operator, and argument nodes.
    #
    # @see #condition
    #
    def _not(target, operator, argument = nil)
      node = condition(target, operator, argument)
      node.updated(:not)
    end

    # Logically OR two or more child nodes together. Does not implicitly create a logical group with parentheses.
    # If you want to logically group the ORs, see {#logical_group}.
    #
    # @example
    #   nodes = CSDL::Builder.new._or do
    #     [
    #       condition("fb.content", :contains, "this is a string"),
    #       condition("fb.parent.content", :contains, "this is a string")
    #     ]
    #   end
    #   CSDL::Processor.new.process(nodes) # => 'fb.content contains "this is a string" OR fb.parent.content contains "this is a string"'
    #
    # @param block [Proc] Block to return child nodes to apply to this :or node. Block is evaluated against the builder instance.
    # @yieldreturn [AST::Node, Array<AST::Node>] An AST node or array of AST nodes to be wrapped by an :or node.
    # @return [AST::Node] An AST :or node with its children being the node(s) returned by the block.
    #
    # @see #logical_group
    #
    def _or(&block)
      children = __one_or_more_child_nodes(&block)
      if children.empty?
        nil
      elsif children.size == 1
        children.first
      else
        s(:or, *children)
      end
    end

    # Wrap child nodes in a return statement scope.
    #
    # @note The base {Processor} will not process return statement nodes, use {InteractionFilterProcessor} instead.
    #
    # @example
    #   nodes = CSDL::Builder.new._return do
    #     condition("fb.content", :contains, "this is a string")
    #   end
    #   CSDL::InteractionFilterProcessor.new.process(nodes) # => 'return {fb.content contains "this is a string"}'
    #
    # @param block [Proc] Block to return child nodes to apply to a :statement_scope node. Block is evaluated against the builder instance.
    # @yieldreturn [AST::Node, Array<AST::Node>] An AST node or array of AST nodes to be wrapped by a :statement_scope node.
    #
    # @return [AST::Node] An AST :return node with a single child :statement_scope node, its children being the node(s) returned by the block.
    #
    # @see #statement_scope
    #
    def _return(&block)
      s(:return, statement_scope(&block))
    end

    # Create a "target + operator[ + argument]" CSDL condition. This method is the workhorse of any CSDL Filter.
    # See {#_not} if you wish to negate a single condition.
    #
    # @example
    #   node = CSDL::Builder.new.condition("fb.content", :contains, "match this string")
    #   CSDL::Processor.new.process(node) # => 'fb.content contains "match this string"'
    #
    # @example Multiple conditions ANDed together
    #   nodes = CSDL::Builder.new._and do
    #     [
    #       condition("fb.content", :contains, "this is a string"),
    #       condition("fb.parent.content", :contains, "this is a string"),
    #     ]
    #   end
    #   CSDL::Processor.new.process(nodes) # => 'fb.content contains "this is a string" AND fb.parent.content contains "this is a string"'
    #
    # @param target [#to_s] A valid Target specifier (see {CSDL::TARGETS}).
    # @param operator [#to_s] A valid Operator specifier (see {CSDL::OPERATORS}).
    # @param argument [String, Numeric, nil] The comparator value, if applicable for the given operator.
    #
    # @return [AST::Node] An AST :condition node with child target, operator, and argument nodes.
    #
    # @see #_not
    #
    def condition(target, operator, argument = nil)
      target_node   = s(:target, target)
      operator_node = s(:operator, operator)
      argument_node = nil

      unless argument.nil?
        argument_node_type  = argument.class.name.to_s.downcase.to_sym
        child_argument_node = s(argument_node_type, argument)
        argument_node       = s(:argument, child_argument_node)
      end

      s(:condition, *[target_node, operator_node, argument_node].compact)
    end

    # Wrap any child nodes in a logical grouping with parentheses. Additionally specify a logical
    # operator to wrap all block child nodes. See {#_or} and {#_and}.
    #
    # @example
    #   nodes = CSDL::Builder.new.logical_group do
    #     condition("fb.content", :contains, "this is a string")
    #   end
    #   CSDL::Processor.new.process(nodes) # => '(fb.content contains "this is a string")'
    #
    # @example Without logical operator argument (default)
    #   nodes = CSDL::Builder.new.logical_group do
    #     _or do
    #       [
    #         condition("fb.content", :contains, "this is a string"),
    #         condition("fb.parent.content", :contains, "this is a string")
    #       ]
    #     end
    #   end
    #   CSDL::Processor.new.process(nodes) # => '(fb.content contains "this is a string" OR fb.parent.content contains "this is a string")'
    #
    # @example With logical operator argument, notice removal of _or block from previous example
    #   nodes = CSDL::Builder.new.logical_group(:or) do
    #     [
    #       condition("fb.content", :contains, "this is a string"),
    #       condition("fb.parent.content", :contains, "this is a string")
    #     ]
    #   end
    #   CSDL::Processor.new.process(nodes) # => '(fb.content contains "this is a string" OR fb.parent.content contains "this is a string")'
    #
    # @example Complex example
    #   nodes = CSDL::Builder.new._and do
    #     [
    #       logical_group(:or) {
    #         [
    #           condition("fb.content", :contains, "this is a string"),
    #           condition("fb.parent.content", :contains, "this is a string")
    #         ]
    #       },
    #       logical_group(:or) {
    #         [
    #           condition("fb.author.age", :==, "25-34"),
    #           condition("fb.parent.author.age", :==, "25-34")
    #         ]
    #       },
    #       logical_group(:or) {
    #         [
    #           condition("fb.author.gender", :==, "male"),
    #           condition("fb.parent.author.gender", :==, "male")
    #         ]
    #       },
    #       condition("fb.author.region", :==, "texas")
    #     ]
    #   end
    #   CSDL::Processor.new.process(nodes) # => '(fb.content contains "this is a string" OR fb.parent.content contains "this is a string") AND (fb.author.age == "25-34" OR fb.parent.author.age == "25-34") AND (fb.author.gender == "male" OR fb.parent.author.gender == "male") AND fb.author.region == "texas"'
    #
    # @param block [Proc] Block to return child nodes to apply to this :logical_group node. Block is evaluated against the builder instance.
    # @yieldreturn [AST::Node, Array<AST::Node>] An AST node or array of AST nodes to be wrapped by a :logical_group node (and possibly also a node for the logical operator).
    #
    # @return [AST::Node] An AST :logical_operator node with its children being the node(s) returned by the block.
    #
    # @see #_and
    # @see #_or
    #
    def logical_group(logical_operator = nil, &block)
      children = __one_or_more_child_nodes(&block)
      return nil if children.empty?

      if logical_operator.nil?
        s(:logical_group, *children)
      else
        s(:logical_group, s(logical_operator, *children))
      end
    end

    # Wrap child nodes in a root node. Useful for building CSDL with tagging and a return statement.
    #
    # @example
    #   nodes = CSDL::Builder.new.root do
    #     [
    #       tag_tree(["movies"], "Video") { condition("links.url", :any, "youtube.com,vimeo.com") },
    #       tag_tree(["movies"], "Social Networks") { condition("links.url", :any, "twitter.com,facebook.com") },
    #
    #       return {
    #         _or {
    #           [
    #             condition("fb.topics.category", :in, "Movie,Film,TV"),
    #             condition("fb.parent.topics.category", :in, "Movie,Film,TV")
    #           ]
    #         }
    #       }
    #     ]
    #   end
    #   CSDL::InteractionFilterProcessor.new.process(nodes) # => 'tag.movies "Video" {links.url any "youtube.com,vimeo.com"} tag.movies "Social Networks" {links.url any "twitter.com,facebook.com"} return {fb.topics.category in "Movie,Film,TV" OR fb.parent.topics.cateogry in "Movie,Film,TV"}'
    #
    # @param block [Proc] Block to return child nodes to apply to this :statement_scope node. Block is evaluated against the builder instance.
    # @yieldreturn [AST::Node, Array<AST::Node>] An AST node or array of AST nodes to be wrapped by a :statement_scope node.
    #
    # @return [AST::Node] An AST :statement_scope node with its children being the node(s) returned by the block.
    #
    # @see #_return
    # @see #tag_tree
    #
    def root(&block)
      children = __one_or_more_child_nodes(&block)
      if children.empty?
        nil
      else
        s(:root, *children)
      end
    end

    # Wrap child nodes in braces. @note Generally not useful on its own, see {#_return}, {#tag}, or {#tag_tree} usage.
    #
    # @note The base {Processor} will not process statement_scope nodes, use {InteractionFilterProcessor} instead.
    #
    # @example
    #   nodes = CSDL::Builder.new.statement_scope do
    #     condition("fb.content", :contains, "this is a string")
    #   end
    #   CSDL::InteractionFilterProcessor.new.process(nodes) # => '{fb.content contains "this is a string"}'
    #
    # @param block [Proc] Block to return child nodes to apply to this :statement_scope node. Block is evaluated against the builder instance.
    # @yieldreturn [AST::Node, Array<AST::Node>] An AST node or array of AST nodes to be wrapped by a :statement_scope node.
    #
    # @return [AST::Node] An AST :statement_scope node with its children being the node(s) returned by the block.
    #
    # @see #_return
    # @see #tag
    # @see #tag_tree
    #
    def statement_scope(&block)
      children = __one_or_more_child_nodes(&block)
      if children.empty?
        nil
      else
        s(:statement_scope, *children)
      end
    end

    # Wrap child nodes in a VEDO tag classification.
    #
    # @note The base {Processor} will not process tag nodes, use {InteractionFilterProcessor} instead.
    #
    # @example
    #   nodes = CSDL::Builder.new.tag("MyTag") do
    #     condition("fb.content", :contains, "this is a string")
    #   end
    #   CSDL::InteractionFilterProcessor.new.process(nodes) # => 'tag "MyTag" {fb.content contains "this is a string"}'
    #
    # @param tag_class [#to_s] The tag classification.
    # @param block [Proc] Block to return child nodes to apply to a :statement_scope node nested under the :tag node. Block is evaluated against the builder instance.
    # @yieldreturn [AST::Node, Array<AST::Node>] An AST node or array of AST nodes to be wrapped by a :statement_scope node, to be a child of the returned :tag node.
    #
    # @return [AST::Node] An AST :tag node with a :tag_class child node and :statement_scope child node.
    #
    # @see #statement_scope
    # @see #tag_tree
    #
    def tag(tag_class, &block)
      s(:tag,
        s(:tag_class,
          s(:string, tag_class)),
        statement_scope(&block))
    end

    # Wrap child nodes in a VEDO tag classification tree.
    #
    # @note The base {Processor} will not process tag_tree nodes, use {InteractionFilterProcessor} instead.
    #
    # @example
    #   nodes = CSDL::Builder.new.tag_tree(%w(foo bar), "MyTag") do
    #     condition("fb.content", :contains, "this is a string")
    #   end
    #   CSDL::InteractionFilterProcessor.new.process(nodes) # => 'tag.foo.bar "MyTag" {fb.content contains "this is a string"}'
    #
    # @param tag_namespaces [Array<#to_s>] List of classification namespaces.
    # @param tag_class [#to_s] The tag classification.
    # @param block [Proc] Block to return child nodes to apply to a :statement_scope node nested under the :tag node. Block is evaluated against the builder instance.
    # @yieldreturn [AST::Node, Array<AST::Node>] An AST node or array of AST nodes to be wrapped by a :statement_scope node, to be a child of the returned :tag node.
    #
    # @return [AST::Node] An AST :tag node with a :tag_namespaces child node, :tag_class child node, and :statement_scope child node.
    #
    # @see #statement_scope
    # @see #tag
    #
    def tag_tree(tag_namespaces, tag_class, &block)
      tag_namespace_nodes = tag_namespaces.map do |tag_namespace|
        s(:tag_namespace, tag_namespace)
      end

      s(:tag,
        s(:tag_namespaces,
          *tag_namespace_nodes),
        s(:tag_class,
          s(:string, tag_class)),
        statement_scope(&block))
    end

    private

    def __one_or_more_child_nodes(&block)
      children = instance_eval(&block)
      [ children ].flatten.compact
    end

  end
end
