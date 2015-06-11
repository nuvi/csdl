module CSDL
  class InteractionFilterProcessor < ::CSDL::Processor

    def validate_target!(target_key)
      unless ::CSDL.interaction_target?(target_key)
        fail ::CSDL::InvalidInteractionTargetError, "Interaction filters cannot use target '#{target_key}'"
      end
    end

  end
end
