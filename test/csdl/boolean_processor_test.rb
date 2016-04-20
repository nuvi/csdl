require "test_helper"

class BooleanProcessorTest < ::MiniTest::Test
  include ::AST::Sexp

  def test_and_with_0_children
    assert_raises(::CSDL::MissingChildNodesError) do
      sexp = s(:and)
      ::CSDL::BooleanProcessor.new.process(sexp)
    end
  end

  def test_and_with_1_child
    assert_raises(::CSDL::MissingChildNodesError) do
      sexp = s(:and,
               s(:string, "foo"))
      ::CSDL::BooleanProcessor.new.process(sexp)
    end
  end

  def test_and_with_2_children
    conditions = ["fb.content contains \"foo\"",
                  "fb.content contains \"bar\""]
    expected = s(:AND,
                 s(:exprvar, conditions[0]),
                 s(:exprvar, conditions[1]))
    sexp = s(:and,
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "foo"))),
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "bar"))))
    assert_csdl_equal(expected, sexp, conditions)
  end

  def test_and_with_3_children
    conditions = ["fb.content contains \"foo\"",
                  "fb.content contains \"bar\"",
                  "fb.content contains \"baz\""]
    expected = s(:AND,
                 s(:exprvar, conditions[0]),
                 s(:exprvar, conditions[1]),
                 s(:exprvar, conditions[2]))
    sexp = s(:and,
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "foo"))),
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "bar"))),
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "baz"))))
    assert_csdl_equal(expected, sexp, conditions)
  end

  def test_argument
    expected = %q{"foo"}
    sexp = s(:argument,
             s(:string, "foo"))
    assert_csdl_equal(expected, sexp, [])
  end

  def test_multiple_argument_children
    expected = %q{"foo"}
    sexp = s(:argument,
             s(:string, "foo"),
             s(:string, "bar"))
    assert_csdl_equal(expected, sexp, [])
  end

  def test_empty_logical_group
    assert_raises(::CSDL::MissingChildNodesError) do
      sexp = s(:logical_group)
      ::CSDL::BooleanProcessor.new.process(sexp)
    end
  end

  def test_logical_group_with_condition
    target = ::CSDL::TARGETS.keys.sample
    operator = ::CSDL::OPERATORS.keys.sample
    condition = %Q{#{target} #{operator} "baz"}
    expected = s(:exprvar, condition)
    sexp = s(:logical_group,
             s(:condition,
               s(:target, target),
               s(:operator, operator),
               s(:argument,
                 s(:string, "baz"))))
    assert_csdl_equal(expected, sexp, [condition])
  end

  def test_not
    target = ::CSDL::TARGETS.keys.sample
    operator = ::CSDL::OPERATORS.keys.sample
    condition = %Q{#{target} #{operator} "baz"}
    expected = s(:NOT,
                 s(:exprvar, condition))
    sexp = s(:not,
             s(:target, target),
             s(:operator, operator),
             s(:argument,
               s(:string, "baz")))
    assert_csdl_equal(expected, sexp, [condition])
  end

  def test_not_with_logical_group
    target = ::CSDL::TARGETS.keys.sample
    operator = ::CSDL::OPERATORS.keys.sample
    condition = %Q{#{target} #{operator} "baz"}
    expected = s(:NOT,
                 s(:exprvar, condition))
    sexp = s(:not,
             s(:logical_group,
               s(:condition,
                 s(:target, target),
                 s(:operator, operator),
                 s(:argument,
                   s(:string, "baz")))))
    assert_csdl_equal(expected, sexp, [condition])
  end

  def test_operator
    operator = ::CSDL::OPERATORS.keys.sample
    sexp = s(:operator, operator)
    assert_csdl_equal(operator, sexp, [])
  end

  def test_invalid_operator
    assert_raises(::CSDL::UnknownOperatorError) do
      sexp = s(:operator, "foo")
      ::CSDL::BooleanProcessor.new.process(sexp)
    end
  end

  def test_or_with_0_children
    assert_raises(::CSDL::MissingChildNodesError) do
      sexp = s(:or)
      ::CSDL::BooleanProcessor.new.process(sexp)
    end
  end

  def test_or_with_1_child
    assert_raises(::CSDL::MissingChildNodesError) do
      sexp = s(:or,
               s(:string, "foo"))
      ::CSDL::BooleanProcessor.new.process(sexp)
    end
  end

  def test_or_with_2_children
    conditions = ["fb.content contains \"foo\"",
                  "fb.content contains \"bar\""]
    expected = s(:OR,
                 s(:exprvar, conditions[0]),
                 s(:exprvar, conditions[1]))
    sexp = s(:or,
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "foo"))),
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "bar"))))
    assert_csdl_equal(expected, sexp, conditions)
  end

  def test_or_with_3_children
    conditions = ["fb.content contains \"foo\"",
                  "fb.content contains \"bar\"",
                  "fb.content contains \"baz\""]
    expected = s(:OR,
                 s(:exprvar, conditions[0]),
                 s(:exprvar, conditions[1]),
                 s(:exprvar, conditions[2]))
    sexp = s(:or,
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "foo"))),
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "bar"))),
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "baz"))))
    assert_csdl_equal(expected, sexp, conditions)
  end

  def test_string_with_quotes
    ::CSDL::Processor.any_instance.expects(:on_string).with(s(:string, "arg")).returns("result")
    expected = "result"
    sexp = s(:string, "arg")
    assert_csdl_equal(expected, sexp)
  end

  def test_target
    ::CSDL::Processor.any_instance.expects(:on_target).with(s(:target, "arg")).returns("result")
    expected = "result"
    sexp = s(:target, "arg")
    assert_csdl_equal(expected, sexp)
  end

  def test_condition
    target = ::CSDL::TARGETS.keys.sample
    operator = ::CSDL::OPERATORS.keys.sample
    condition = %Q{#{target} #{operator} "baz"}
    expected = s(:exprvar, condition)
    sexp = s(:condition,
             s(:target, target),
             s(:operator, operator),
             s(:argument,
               s(:string, "baz")))
    assert_csdl_equal(expected, sexp, [condition])
  end

  def test_grouped_expressions
    conditions = ['fb.content contains_any "foo"',
                  'fb.parent.content contains_any "foo"',
                  'fb.content contains_any "bar"',
                  'fb.parent.content contains_any "bar"']
    expected = s(:AND,
                 s(:OR,
                   s(:exprvar, conditions[0]),
                   s(:exprvar, conditions[1])),
                 s(:OR,
                   s(:exprvar, conditions[2]),
                   s(:exprvar, conditions[3])))
    sexp = \
      s(:and,
        s(:logical_group,
          s(:or,
            s(:condition,
              s(:target, "fb.content"),
              s(:operator, :contains_any),
              s(:argument,
                s(:string, "foo")
               )
             ),
             s(:condition,
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
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains_any),
               s(:argument,
                 s(:string, "bar")
                )
              ),
              s(:condition,
                s(:target, "fb.parent.content"),
                s(:operator, :contains_any),
                s(:argument,
                  s(:string, "bar")
                 )
               ),
            )
          )
       )

    assert_csdl_equal(expected, sexp, conditions)
  end

  def test_raw
    raw = %q{fb.content contains_any "foo" OR fb.parent.content contains_any "foo"}
    sexp = s(:raw, raw)
    expected = s(:exprvar, raw)
    assert_csdl_equal(expected, sexp, [raw])
  end

  def test_raw_grouped_with_other_conditions
    conditions = ["fb.type exists",
                  'fb.content contains_any "foo" OR fb.parent.content contains_any "foo"']
    expected = s(:OR,
                 s(:exprvar, conditions[0]),
                 s(:exprvar, conditions[1]))
    sexp = s(:or,
             s(:condition,
               s(:target, "fb.type"),
               s(:operator, :exists)),
             s(:logical_group,
               s(:raw, %q{fb.content contains_any "foo" OR fb.parent.content contains_any "foo"})))


    assert_csdl_equal(expected, sexp, conditions)
  end

  private

  def assert_csdl_equal(expected, sexp, conditions = nil)
    processor = ::CSDL::BooleanProcessor.new
    assert_equal(expected, processor.process(sexp))
    assert_equal(conditions, processor.conditions.keys) if conditions
  end
end
