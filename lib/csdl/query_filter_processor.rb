module CSDL

  # {QueryFilterProcessor} is a class that inherits from {Processor}, providing additional methods
  # for building CSDL specifically for Query Filters.
  #
  # @see Processor
  # @see Builder
  # @see http://www.rubydoc.info/gems/ast/AST/Processor AST::Processor
  # @see http://www.rubydoc.info/gems/ast/AST/Node AST::Node
  # @see http://dev.datasift.com/docs/csdl DataSift CSDL Language Documentation
  #
  class QueryFilterProcessor < ::CSDL::Processor

    # Raises an {InvalidQueryTargetError} if the target isn't a valid CSDL target for query filters. Will
    # be called from the base class when given a :condition node with a :target node.
    #
    # @example
    #   CSDL::QueryFilterProcessorProcessor.new.validate_target!("fake") # => raises InvalidQueryTargetError
    #
    # @param target_key [String] The target to validate.
    #
    # @return [void]
    #
    # @raise [InvalidQueryTargetError] When the terminator value is not a valid query filter target. See {CSDL.query_target?}.
    #
    # @see Processor#on_condition
    # @see Processor#on_target
    #
    def validate_target!(target_key)
      unless ::CSDL.query_target?(target_key)
        fail ::CSDL::InvalidQueryTargetError, "Query filters cannot use target '#{target_key}'"
      end
    end

  end
end

