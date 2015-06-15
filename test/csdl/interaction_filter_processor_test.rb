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

  def test_empty_on_return
    assert_raises(::CSDL::MissingReturnStatementScopeError) do
      ::CSDL::InteractionFilterProcessor.new.process(s(:return))
    end

    assert_raises(::CSDL::MissingReturnStatementScopeError) do
      sexp = s(:return,
               s(:string, "foo"))
      ::CSDL::InteractionFilterProcessor.new.process(sexp)
    end
  end

  def test_on_return
    expected = %q{return {"foo"}}
    sexp = s(:return,
             s(:statement_scope,
               s(:string, "foo")))
    assert_csdl_equal(expected, sexp)
  end

  def test_empty_on_statement_scope
    expected = "{}"
    sexp = s(:statement_scope)
    assert_csdl_equal(expected, sexp)
  end

  def test_on_statement_scope_with_filter
    target = ::CSDL::TARGETS.keys.sample
    operator = ::CSDL::OPERATORS.keys.sample
    expected = %Q{{#{target} #{operator} "baz"}}
    sexp = s(:statement_scope,
             s(:filter,
               s(:target, target),
               s(:operator, operator),
               s(:argument,
                 s(:string, "baz"))))
    assert_csdl_equal(expected, sexp)
  end

  def test_on_tag_name
    expected = %q{"MyTag"}
    sexp = s(:tag_name,
             s(:string, "MyTag"))
    assert_csdl_equal(expected, sexp)
  end

  def test_on_tag
    expected = %q{tag "MyTag" {"foo"}}
    sexp = s(:tag,
             s(:tag_name,
               s(:string, "MyTag")),
             s(:statement_scope,
               s(:string, "foo")))
    assert_csdl_equal(expected, sexp)
  end

  def test_on_tag_with_missing_tag_name
    assert_raises(::CSDL::MissingTagNameError) do
      sexp = s(:tag,
               s(:statement_scope,
                 s(:string, "foo")))
      ::CSDL::InteractionFilterProcessor.new.process(sexp)
    end
  end

  def test_on_tag_with_missing_statement_scope
    assert_raises(::CSDL::MissingTagStatementScopeError) do
      sexp = s(:tag,
               s(:tag_name,
                 s(:string, "foo")))
      ::CSDL::InteractionFilterProcessor.new.process(sexp)
    end
  end

  private

  def assert_csdl_equal(expected, sexp)
    assert_equal(expected, ::CSDL::InteractionFilterProcessor.new.process(sexp))
  end

end

