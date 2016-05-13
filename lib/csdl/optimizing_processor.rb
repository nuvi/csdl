module CSDL

  # {OptimizingProcessor} is a class that can take a tree of AST::Node objects built with {Builder}
  # and optimize it.
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
  #   CSDL::OptimizingProcessor.new.process(root_node)
  #
  # @see Builder
  # @see http://www.rubydoc.info/gems/ast/AST/Processor AST::Processor
  # @see http://www.rubydoc.info/gems/ast/AST/Node AST::Node
  # @see http://dev.datasift.com/docs/csdl DataSift CSDL Language Documentation
  #
  class OptimizingProcessor < ::AST::Processor

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
    #   CSDL::OptimizingProcessor.new.process(node)
    #   # => s(:condition,
    #   #      s(:target, "fb.content"),
    #   #      s(:operator, :contains_all),
    #   #      s(:argument,
    #   #        s(:string, "foo,bar")))
    #
    # @param node [AST::Node] The :and node to be processed.
    #
    # @raise [MissingChildNodesError] When less than 2 child nodes are present.
    # @raise [InvalidChildNodeError] When it has a child that is neither a condition nor a logical expression.
    #
    # @return [String] Processed child nodes ANDed together into a boolean expression representation.
    #
    def on_and(node)
      process_and_or_group(node)
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
    #   CSDL::OptimizingProcessor.new.process(node)
    #   # => s(:condition,
    #   #      s(:target, "fb.content"),
    #   #      s(:operator, :contains_any),
    #   #      s(:argument,
    #   #        s(:string, "foo,bar")))
    #
    # @param node [AST::Node] The :or node to be processed.
    #
    # @raise [MissingChildNodesError] When less than 2 child nodes are present.
    # @raise [InvalidChildNodeError] When it has a child that is neither a condition nor a logical expression.
    #
    # @return [String] Processed child nodes OR'd together into a boolean expression.
    #
    def on_or(node)
      process_and_or_group(node)
    end

    def on_logical_group(node)
      ::AST::Node.new(:logical_group, [process(node.children.first)])
    end

    private

    def process_and_or_group(node)
      mapping = {}
      processed_children = process_all(node.children)
      result_nodes = []
      processed_children.each do |child|
        unless [:condition, :not].include?(child.type)
          result_nodes << child
          next
        end
        child = child.children.first if child.type == :logical_group
        key_two = child.type
        operator = child.children.find { |grandchild| grandchild.type == :operator }.children.first.to_sym
        unless [:contains, :contains_any, :contains_all].include?(operator)
          result_nodes << child
          next
        end
        key_three = operator

        # Groupping Operator  Condition Type    RESULT
        #         :and         :condition    :contains_all
        #         :and         :not          :contains_any
        #         :or          :condition    :contains_any
        #         :or          :not          :contains_all
        key_three = (((key_two == :condition) ^ (node.type != :and)) ? :contains_all : :contains_any) if key_three == :contains

        target = child.children.find { |grandchild| grandchild.type == :target }.children.first
        key_one = target.to_s
        mapping[key_one] ||= {}
        mapping[key_one][key_two] ||= {}
        mapping[key_one][key_two][key_three] ||= []
        argument = child.children.find { |grandchild| grandchild.type == :argument }.children.first.children.first
        mapping[key_one][key_two][key_three] << argument
      end
      mapping.each_pair do |target_string, target_mapping|
        target_mapping.each_pair do |condition_type, condition_mapping|
          condition_mapping.each_pair do |words_operator, words|
            words_string = words.join(",")
            words = words_string.split(/(?<!\\),/).sort.uniq
            result_operator = words.count == 1 ? :contains : words_operator
            result_nodes << AST::Node.new(condition_type,
                              [
                                AST::Node.new(:target, [target_string]),
                                AST::Node.new(:operator, [result_operator]),
                                AST::Node.new(:argument, [AST::Node.new(:string, [words.join(",")])])
                              ])
          end
        end
      end
      result_nodes.count == 1 ? result_nodes.first : AST::Node.new(node.type, result_nodes)
    end
  end
end
