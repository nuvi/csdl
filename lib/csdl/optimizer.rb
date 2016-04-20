module CSDL

  # {Optimizer} is a class used to optimize CSDL trees treating them as boolean expressions.
  # After doing boolean expression optimization the {Optimizer} will glue multiple "contains" conditions
  # into "contains_any" and "contains_all" conditions according to the expression's logic.
  #
  # @example
  #   # Generate optimized CSDL tree using the Optimizer
  #   optimized_logical_group = CSDL::Optimizer.new.optimize(logical_group)
  #
  # @see http://dev.datasift.com/docs/csdl DataSift CSDL Language Documentation
  #
  class Optimizer
    # Optimize a CSDL tree treating it as a boolean expression.
    # After doing boolean expression optimization the {Optimizer} will glue multiple "contains" conditions
    # into "contains_any" and "contains_all" conditions according to the expression's logic.
    #
    # @example
    #   tree = CSDL::Builder.new.logical_group do
    #     _or do
    #       [
    #         logical_group do
    #           _and do
    #             [
    #               condition("fb.content", :contains, "apple"),
    #               _not("fb.content", :contains, "book"),
    #               _not("fb.content", :contains, "cat"),
    #             ]
    #            end
    #         end,
    #         logical_group do
    #           _and do
    #             [
    #               _not("fb.content", :contains, "apple"),
    #               _not("fb.content", :contains, "book"),
    #               condition("fb.content", :contains, "cat"),
    #             ]
    #            end
    #         end,
    #         logical_group do
    #           _and do
    #             [
    #               condition("fb.content", :contains, "apple"),
    #               _not("fb.content", :contains, "book"),
    #               condition("fb.content", :contains, "cat"),
    #             ]
    #            end
    #         end,
    #         logical_group do
    #           _and do
    #             [
    #               condition("fb.content", :contains, "apple"),
    #               condition("fb.content", :contains, "book"),
    #               condition("fb.content", :contains, "cat"),
    #             ]
    #            end
    #         end,
    #         logical_group do
    #           _and do
    #             [
    #               condition("fb.content", :contains, "apple"),
    #               condition("fb.content", :contains, "book"),
    #               _not("fb.content", :contains, "cat"),
    #             ]
    #            end
    #         end
    #       ]
    #     end
    #   end
    #   optimized_tree = CSDL::Optimizer.new.optimize(tree)
    #   CSDL::Processor.new.process(optimized_tree) # => 'NOT fb.content contains_any "apple,book" OR fb.content contains_all "apple,book" OR NOT fb.content contains "book" AND fb.content contains "cat"'
    #
    # @param  node [AST::Node] The CSDL tree to optimize.
    # @return [AST::Node] An optimized CSDL as an AST node with its children.
    #
    def optimize(node)
      return node
    end

    private

    def generate_boolean_tree(node, unique_conditions = {})
    end
  end
end
