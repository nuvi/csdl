module CSDL
  class QueryFilterProcessor < ::CSDL::Processor

    def validate_target!(target_key)
      unless ::CSDL.query_target?(target_key)
        fail ::CSDL::InvalidQueryTargetError, "Query filters cannot use target '#{target_key}'"
      end
    end

  end
end

