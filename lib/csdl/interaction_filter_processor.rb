module CSDL

  # {InteractionFilterProcessor} is a class that inherits from {Processor}, providing additional methods
  # for building CSDL specifically for Interaction Filters.
  #
  # Additional DSL methods provide the return statement, curly brace scopes (statement scopes), and VEDO tagging.
  #
  # @example
  #   nodes = CSDL::Builder.new.root do
  #     [
  #       tag_tree(%w(movies), "Video") {
  #         condition("links.url", :any, "youtube.com,vimeo.com")
  #       },
  #       tag_tree(%w(movies), "Social Networks") {
  #         condition("links.url", :any, "twitter.com,facebook.com")
  #       },
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
  # @see Processor
  # @see Builder
  # @see http://www.rubydoc.info/gems/ast/AST/Processor AST::Processor
  # @see http://www.rubydoc.info/gems/ast/AST/Node AST::Node
  # @see http://dev.datasift.com/docs/csdl DataSift CSDL Language Documentation
  #
  class InteractionFilterProcessor < ::CSDL::Processor

    # Generate a return statement by processing the child statement_scope node.
    #
    # @raise [MissingReturnStatementScopeError] When the :return node is missing a :statement_scope child node.
    #
    # @example
    #   node = s(:return,
    #            s(:statement_scope,
    #             s(:string, "foo")))
    #   CSDL::InteractionFilterProcessor.new.process(node) # => 'return {"foo"}'
    #
    # @param node [AST::Node] The :return node to be processed.
    #
    # @return [String] The processed :statement_scope child node, prepended by the "return" keyword.
    #
    def on_return(node)
      statement_scope = node.children.compact.find { |child| child.type == :statement_scope }

      if statement_scope.nil?
        fail ::CSDL::MissingReturnStatementScopeError, "Invalid CSDL AST: return statment scope is missing"
      end

      "return #{process(statement_scope)}"
    end

    # Wrap child nodes in braces. Generally not useful on its own, see {#on_return} or {#on_tag} for integrated usage.
    #
    # @example
    #   node = s(:statement_scope,
    #           s(:string, "foo"))
    #   CSDL::InteractionFilterProcessor.new.process(node) # => '{"foo"}'
    #
    # @param node [AST::Node] The :statement_scope node to be processed.
    #
    # @return [String] The processed child nodes, joined by an empty space and wrapped in braces.
    #
    # @see #on_return
    # @see #on_tag
    #
    def on_statement_scope(node)
      "{" + process_all(node.children.compact).join(" ") + "}"
    end

    # Process :tag node with it's child nodes :tag_namespaces (optional), :tag_class, and :statement_scope.
    #
    # @example Tag Classification
    #   node = s(:tag,
    #           s(:tag_class,
    #            s(:string, "MyTag")),
    #           s(:statement_scope,
    #            s(:string, "foo")))
    #   CSDL::InteractionFilterProcessor.new.process(node) # => 'tag "MyTag" {"foo"}'
    #
    # @example Tag Tree Classification
    #   node = s(:tag,
    #           s(:tag_namespaces,
    #            s(:tag_namespace, "foo"),
    #            s(:tag_namespace, "bar"),
    #            s(:tag_namespace, "baz")),
    #           s(:tag_class,
    #            s(:string, "MyTag")),
    #           s(:statement_scope,
    #            s(:string, "value")))
    #   CSDL::InteractionFilterProcessor.new.process(node) # => 'tag.foo.bar.baz "MyTag" {"value"}'
    #
    # @param node [AST::Node] The :tag node to be processed.
    #
    # @return [String] The tag classifier raw CSDL.
    #
    # @raise [MissingTagClassError] When we don't have a first-level :tag_namespaces child.
    # @raise [MissingTagStatementScopeError] When we don't have a first-level :statement_scope child.
    #
    def on_tag(node)
      children = node.children.compact
      tag_namespaces  = children.find { |child| child.type == :tag_namespaces }
      tag_class       = children.find { |child| child.type == :tag_class }
      statement_scope = children.find { |child| child.type == :statement_scope }

      if tag_class.nil?
        fail ::CSDL::MissingTagClassError, "Invalid CSDL AST: :tag node must have a :tag_class child node"
      end

      if statement_scope.nil?
        fail ::CSDL::MissingTagStatementScopeError, "Invalid CSDL AST: :tag node must have a :statement_scope child node"
      end

      tag_namespace = "tag"
      unless tag_namespaces.nil?
        tag_namespace += process(tag_namespaces)
      end

      children = [tag_namespace] + process_all([ tag_class, statement_scope ])
      children.join(" ")
    end

    # Process the first child of the :tag_class node.
    #
    # @param node [AST::Node] The :tag_class node to be processed.
    #
    # @return [String] The processed value of the first child node.
    #
    # @see #on_tag
    #
    def on_tag_class(node)
      process(node.children.first)
    end

    # Process the terminal value of the :tag_namespace node.
    #
    # @param node [AST::Node] The :tag_namespace node to be processed.
    #
    # @return [String] Terminal value as a string.
    #
    # @see #on_tag_namespaces
    #
    def on_tag_namespace(node)
      node.children.first.to_s
    end

    # Process the :tag_namespace child nodes of a :tag_namespaces node.
    #
    # @example
    #   node = s(:tag_namespaces,
    #           s(:tag_namespace, "foo"),
    #           s(:tag_namespace, "bar"),
    #           s(:tag_namespace, "baz"))
    #   CSDL::InteractionFilterProcessor.new.process(node) # => '.foo.bar.baz'
    #
    # @param node [AST::Node] The :tag_namespaces node to be processed.
    #
    # @return [String] Dot-delimited tag node namespace.
    #
    # @raise [MissingTagNodesError] When there aren't any first-level :tag_namespace child nodes.
    #
    def on_tag_namespaces(node)
      child_tag_namespaces = node.children.compact.select { |child| child.type == :tag_namespace }

      if child_tag_namespaces.empty?
        fail ::CSDL::MissingTagNodesError, "Invalid CSDL AST: A :tag_namespaces node must have at least one :tag_namespace child"
      end

      "." + process_all(child_tag_namespaces).join(".")
    end

    # Raises an {InvalidInteractionTargetError} if the target isn't a valid CSDL target for interaction filters. Will
    # be called from the base class when given a :condition node with a :target node.
    #
    # @example
    #   CSDL::InteractionFilterProcessorProcessor.new.validate_target!("fake") # => raises InvalidInteractionTargetError
    #
    # @param target_key [String] The target to validate.
    #
    # @return [void]
    #
    # @raise [InvalidInteractionTargetError] When the terminator value is not a valid ineraction filter target. See {CSDL.interaction_target?}.
    #
    # @see Processor#on_condition
    # @see Processor#on_target
    #
    def validate_target!(target_key)
      unless ::CSDL.interaction_target?(target_key)
        fail ::CSDL::InvalidInteractionTargetError, "Interaction filters cannot use target '#{target_key}'"
      end
    end

  end
end
