require "open3"

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
    # Instance contructor
    #
    # @param skip_espresso  [Boolean] Pass 'true' to external optimization with by expresso algorithm
    #
    # @see Optimizer#optimize
    #
    def initialize(skip_espresso = false)
      @skip_espresso = skip_espresso
    end

    # Optimize a CSDL tree treating it as a boolean expression.
    # After doing boolean expression optimization the {Optimizer} will glue multiple "contains" conditions
    # into "contains_any" and "contains_all" conditions according to the expression's logic.
    #
    # @raise [FalseExpressionError] when the tree represents FALSE expression.
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
    #
    # @param  node [AST::Node] The CSDL tree to optimize.
    # @return [AST::Node] An optimized CSDL as an AST node with its children.
    #
    def optimize(node)
      processor = BooleanProcessor.new
      expression = processor.process(node)
      return nil unless expression && !expression.empty?
      if @skip_espresso
        ast = expression
      else
        vars = processor.conditions_origins.keys.map { |varname| "#{varname} = exprvar('#{varname}')" }.join("\n")
        script = "from pyeda.inter import *\n" \
                 "#{vars}\n"\
                 "f = #{expression}\n" \
                 "f = f.to_dnf()\n" \
                 "if f == expr(0):\n" \
                 "  print('0', end='')\n" \
                 "elif f != expr(1):\n" \
                 "  fm, = espresso_exprs(f.to_dnf())\n" \
                 "  if fm == expr(0):\n" \
                 "    print('0', end='')\n" \
                 "  elif fm != expr(1):\n" \
                 "    print(fm, end='')"
        Open3.popen3("python3") do |stdin, stdout, stderr, wait_thr|
          stdin.write(script)
          stdin.close
          exit_status = wait_thr.value
          fail StandardError, "Error executing pyeda espresso (#{exit_status}): #{stderr.read}" unless exit_status.success?
          expression = stdout.read
        end
        return nil if expression == ""
        raise FalseExpressionError, "The given conditions are always FALSE" if expression == "0"
        tokens = ::CSDL::BooleanLexer.new.lex(expression)
        ast = ::CSDL::BooleanParser.new(processor.conditions_origins).parse(tokens.dup)
      end
      result = ::CSDL::OptimizingProcessor.new.process(ast)
      result
    end
  end
end
