require "test_helper"

class ProcessorTest < ::MiniTest::Test
  include ::AST::Sexp

  def test_and_with_0_children
    assert_raises(::CSDL::MissingChildNodesError) do
      sexp = s(:and)
      ::CSDL::Processor.new.process(sexp)
    end
  end

  def test_and_with_1_child
    assert_raises(::CSDL::MissingChildNodesError) do
      sexp = s(:and,
               s(:string, "foo"))
      ::CSDL::Processor.new.process(sexp)
    end
  end

  def test_and_with_2_children
    expected = %q{"foo" AND "bar"}
    sexp = s(:and,
            s(:string, "foo"),
            s(:string, "bar"))
    assert_csdl_equal(expected, sexp)
  end

  def test_and_with_3_children
    expected = %q{"foo" AND "bar" AND "baz"}
    sexp = s(:and,
            s(:string, "foo"),
            s(:string, "bar"),
            s(:string, "baz"))
    assert_csdl_equal(expected, sexp)
  end

  def test_argument
    expected = %q{"foo"}
    sexp = s(:argument,
             s(:string, "foo"))
    assert_csdl_equal(expected, sexp)
  end

  def test_multiple_argument_children
    expected = %q{"foo"}
    sexp = s(:argument,
             s(:string, "foo"),
             s(:string, "bar"))
    assert_csdl_equal(expected, sexp)
  end

  def test_empty_logical_group
    expected = "()"
    sexp = s(:logical_group)
    assert_csdl_equal(expected, sexp)
  end

  def test_logical_group_with_filter
    target = ::CSDL::TARGETS.keys.sample
    operator = ::CSDL::OPERATORS.keys.sample
    expected = %Q{(#{target} #{operator} "baz")}
    sexp = s(:logical_group,
             s(:filter,
               s(:target, target),
               s(:operator, operator),
               s(:argument,
                 s(:string, "baz"))))
    assert_csdl_equal(expected, sexp)
  end

  def test_not
    target = ::CSDL::TARGETS.keys.sample
    operator = ::CSDL::OPERATORS.keys.sample
    expected = %Q{NOT #{target} #{operator} "baz"}
    sexp = s(:not,
             s(:target, target),
             s(:operator, operator),
             s(:argument,
               s(:string, "baz")))
    assert_csdl_equal(expected, sexp)
  end

  def test_operator
    operator = ::CSDL::OPERATORS.keys.sample
    sexp = s(:operator, operator)
    assert_csdl_equal(operator, sexp)
  end

  def test_invalid_operator
    assert_raises(::CSDL::UnknownOperatorError) do
      sexp = s(:operator, "foo")
      ::CSDL::Processor.new.process(sexp)
    end
  end

  def test_or_with_0_children
    assert_raises(::CSDL::MissingChildNodesError) do
      sexp = s(:or)
      ::CSDL::Processor.new.process(sexp)
    end
  end

  def test_or_with_1_child
    assert_raises(::CSDL::MissingChildNodesError) do
      sexp = s(:or,
               s(:string, "foo"))
      ::CSDL::Processor.new.process(sexp)
    end
  end

  def test_or_with_2_children
    expected = %q{"foo" OR "bar"}
    sexp = s(:or,
            s(:string, "foo"),
            s(:string, "bar"))
    assert_csdl_equal(expected, sexp)
  end

  def test_or_with_3_children
    expected = %q{"foo" OR "bar" OR "baz"}
    sexp = s(:or,
            s(:string, "foo"),
            s(:string, "bar"),
            s(:string, "baz"))
    assert_csdl_equal(expected, sexp)
  end

  def test_string_with_quotes
    expected = '"this string has \"quotes\""'
    sexp = s(:string, 'this string has "quotes"')
    assert_csdl_equal(expected, sexp)
  end

  def test_target
    target = ::CSDL::TARGETS.keys.sample
    sexp = s(:target, target)
    assert_csdl_equal(target, sexp)
  end

  def test_filter
    target = ::CSDL::TARGETS.keys.sample
    operator = ::CSDL::OPERATORS.keys.sample
    expected = %Q{#{target} #{operator} "baz"}
    sexp = s(:filter,
             s(:target, target),
             s(:operator, operator),
             s(:argument,
               s(:string, "baz")))
    assert_csdl_equal(expected, sexp)
  end

  def test_grouped_expressions
    expected = %q{(fb.content contains_any "foo" OR fb.parent.content contains_any "foo") AND (fb.content contains_any "bar" OR fb.parent.content contains_any "bar")}
    sexp = \
      s(:and,
        s(:logical_group,
          s(:or,
            s(:filter,
              s(:target, "fb.content"),
              s(:operator, :contains_any),
              s(:argument,
                s(:string, "foo")
               )
             ),
             s(:filter,
               s(:target, "fb.parent.content"),
               s(:operator, :contains_any),
               s(:argument,
                 s(:string, "foo")
                )
              ),
           ),
         ),
         s(:logical_group,
           s(:or,
             s(:filter,
               s(:target, "fb.content"),
               s(:operator, :contains_any),
               s(:argument,
                 s(:string, "bar")
                )
              ),
              s(:filter,
                s(:target, "fb.parent.content"),
                s(:operator, :contains_any),
                s(:argument,
                  s(:string, "bar")
                 )
               ),
            )
          )
       )

    assert_csdl_equal(expected, sexp)
  end

  private

  def assert_csdl_equal(expected, sexp)
    assert_equal(expected, ::CSDL::Processor.new.process(sexp))
  end

end
