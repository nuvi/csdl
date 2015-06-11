require "ast"

module CSDL
  class Builder
    include ::AST::Sexp

    def closure(&block)
      __multi(:closure, &block)
    end

    def _or(&block)
      __multi(:or, &block)
    end

    def _and(&block)
      __multi(:and, &block)
    end

    def _not(target, operator, argument)
      node = where(target, operator, argument)
      node.updated(:not)
    end

    def where(target, operator, argument = nil)
      target_node = s(:target, target)
      operator_node = s(:operator, operator)
      argument_node = nil

      unless argument.nil?
        argument_node_type = argument.class.name.to_s.downcase.to_sym
        child_argument_node = s(argument_node_type, argument)
        argument_node = s(:argument, child_argument_node)
      end

      s(:where, *[target_node, operator_node, argument_node].compact)
    end

    def __multi(type, &block)
      children = instance_eval(&block)
      children = [ children ].flatten

      if children.empty?
        s(type)
      else
        s(type, *children)
      end
    end

  end
end
