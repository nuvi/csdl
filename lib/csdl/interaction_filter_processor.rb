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
      tag_nodes       = node.children.find { |child| child.type == :tag_nodes }
      tag_class       = node.children.find { |child| child.type == :tag_class }
      statement_scope = node.children.find { |child| child.type == :statement_scope }

      if tag_class.nil?
        fail ::CSDL::MissingTagClassError, "Invalid CSDL AST: :tag node must have a :tag_class child node"
      end

      if statement_scope.nil?
        fail ::CSDL::MissingTagStatementScopeError, "Invalid CSDL AST: :tag node must have a :statement_scope child node"
      end

      tag_namespace = "tag"
      unless tag_nodes.nil?
        tag_namespace += process(tag_nodes)
      end

      children = [tag_namespace] + process_all([ tag_class, statement_scope ])
      children.join(" ")
    end

    def on_tag_class(node)
      process(node.children.first)
    end

    def on_tag_node(node)
      node.children.first.to_s
    end

    def on_tag_nodes(node)
      child_tag_nodes = node.children.select { |child| child.type == :tag_node }

      if child_tag_nodes.empty?
        fail ::CSDL::MissingTagNodesError, "Invalid CSDL AST: A :tag_nodes node must have at least one :tag_node child"
      end

      "." + process_all(child_tag_nodes).join(".")
    end

    def validate_target!(target_key)
      unless ::CSDL.interaction_target?(target_key)
        fail ::CSDL::InvalidInteractionTargetError, "Interaction filters cannot use target '#{target_key}'"
      end
    end

  end
end
