module CSDL
  class InteractionFilterProcessor < ::CSDL::Processor

    def on_return(node)
      statement_scope = node.children.find { |child| child.type == :statement_scope }

      if statement_scope.nil?
        fail ::CSDL::MissingReturnStatementScopeError, "Invalid CSDL AST: return statment scope is missing"
      end

      "return #{process(statement_scope)}"
    end

    def on_statement_scope(node)
      "{" + process_all(node.children).join(" ") + "}"
    end

    def on_tag(node)
      tag_name        = node.children.find { |child| child.type == :tag_name }
      statement_scope = node.children.find { |child| child.type == :statement_scope }

      if tag_name.nil?
        fail ::CSDL::MissingTagNameError, "Invalid CSDL AST: :tag node must have a :tag_name child node"
      end

      if statement_scope.nil?
        fail ::CSDL::MissingTagStatementScopeError, "Invalid CSDL AST: :tag node must have a :statement_scope child node"
      end

      children = ["tag"] + process_all([ tag_name, statement_scope ])
      children.join(" ")
    end

    def on_tag_name(node)
      process(node.children.first)
    end

    def validate_target!(target_key)
      unless ::CSDL.interaction_target?(target_key)
        fail ::CSDL::InvalidInteractionTargetError, "Interaction filters cannot use target '#{target_key}'"
      end
    end

  end
end
