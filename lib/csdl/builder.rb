module CSDL
  class Builder
    include ::AST::Sexp

    def __one_or_more_child_nodes(&block)
      children = instance_eval(&block)
      [ children ].flatten
    end

    def _or(&block)
      s(:or, *__one_or_more_child_nodes(&block))
    end

    def _and(&block)
      s(:and, *__one_or_more_child_nodes(&block))
    end

    def _not(target, operator, argument = nil)
      node = filter(target, operator, argument)
      node.updated(:not)
    end

    def _return(&block)
      s(:return, statement_scope(&block))
    end

    def filter(target, operator, argument = nil)
      target_node   = s(:target, target)
      operator_node = s(:operator, operator)
      argument_node = nil

      unless argument.nil?
        argument_node_type  = argument.class.name.to_s.downcase.to_sym
        child_argument_node = s(argument_node_type, argument)
        argument_node       = s(:argument, child_argument_node)
      end

      s(:filter, *[target_node, operator_node, argument_node].compact)
    end

    def logical_group(&block)
      s(:logical_group, *__one_or_more_child_nodes(&block))
    end

    def statement_scope(&block)
      s(:statement_scope, *__one_or_more_child_nodes(&block))
    end

  end
end
