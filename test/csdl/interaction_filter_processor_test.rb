require "test_helper"

class InteractionFilterProcessorTest < ::MiniTest::Test
  include ::AST::Sexp

  def test_valid_interaction_targets
    ::CSDL::INTERACTION_TARGETS.keys.each do |target_name|
      assert(::CSDL::InteractionFilterProcessor.new.process(s(:target, target_name)))
    end
  end

  def test_invalid_interaction_target_raises
    assert_raises(::CSDL::InvalidInteractionTargetError) do
      invalid_target = ::CSDL::TARGETS.values.find { |target| ! target.interaction? }
      ::CSDL::InteractionFilterProcessor.new.process(s(:target, invalid_target.name))
    end
  end

end

