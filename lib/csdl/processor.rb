require "ast"
include ::AST::Sexp

module CSDL
  class Processor < ::AST::Processor

    def on_and(node)
      initial = process(node.children.first)
      rest = node.children.drop(1)

      rest.reduce(initial) do |csdl, child|
        csdl += " AND " + process(child)
        csdl
      end
    end

    def on_argument(node)
      process(node.children.first)
    end

    def on_closure(node)
      "(" + process_all(node.children).join(" ") + ")"
    end

    def on_not(node)
      "NOT " + process(node.updated(:filter))
    end

    def on_operator(node)
      operator = node.children.first.to_s
      unless ::CSDL.operator?(operator)
        fail ::CSDL::UnknownOperatorError, "Operator #{operator} is unknown"
      end
      operator
    end

    def on_or(node)
      if node.children.empty?
        fail ::CSDL::MissingChildNodesError, "Invalid CSDL AST: 'or' nodes must contain at least two child nodes. Expected >= 2, got 0"
      end

      initial = process(node.children.first)
      rest = node.children.drop(1)

      if rest.empty?
        fail ::CSDL::MissingChildNodesError, "Invalid CSDL AST: 'or' nodes must contain at least two child nodes. Expected >= 2, got #{node.children.size}"
      end

      rest.reduce(initial) do |csdl, child|
        csdl += " OR " + process(child)
        csdl
      end
    end

    def on_string(node)
      '"' + node.children.first.to_s.gsub(/"/, '\"') + '"'
    end

    def on_target(node)
      target = node.children.first.to_s
      validate_target!(target)
      target
    end

    def on_filter(node)
      target = node.children.find { |child| child.type == :target }
      operator = node.children.find { |child| child.type == :operator }
      argument = node.children.find { |child| child.type == :argument }
      process_all([ target, operator, argument ].compact).join(" ")
    end

    def validate_target!(target_key)
      unless ::CSDL.target?(target_key)
        fail ::CSDL::InvalidQueryTargetError, "Query filters cannot use target '#{target_key}'"
      end
    end

  end
end


