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
    conditions = { "fb.content contains \"foo\"" => "v1",
                   "fb.content contains \"bar\"" => "v2" }
    conditions_origins =
      {
        "v1" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "foo"))),
        "v2" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "bar")))
      }
    expected = "And(v1,v2)"
    sexp = s(:and,
             conditions_origins["v1"],
             conditions_origins["v2"])
    assert_csdl_equal(expected, sexp, conditions, conditions_origins)
  end

  def test_and_with_3_children
    conditions = { "fb.content contains \"foo\"" => "v1",
                   "fb.content contains \"bar\"" => "v2",
                   "fb.content contains \"baz\"" => "v3" }
    conditions_origins =
      {
        "v1" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "foo"))),
        "v2" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "bar"))),
        "v3" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "baz")))
      }

    expected = "And(v1,v2,v3)"
    sexp = s(:and,
             conditions_origins["v1"],
             conditions_origins["v2"],
             conditions_origins["v3"])
    assert_csdl_equal(expected, sexp, conditions, conditions_origins)
  end

  def test_argument
    expected = %q{"foo"}
    sexp = s(:argument,
             s(:string, "foo"))
    assert_csdl_equal(expected, sexp, {}, {})
  end

  def test_multiple_argument_children
    expected = %q{"foo"}
    sexp = s(:argument,
             s(:string, "foo"),
             s(:string, "bar"))
    assert_csdl_equal(expected, sexp, {}, {})
  end

  def test_empty_logical_group
    assert_raises(::CSDL::MissingChildNodesError) do
      sexp = s(:logical_group)
      ::CSDL::BooleanProcessor.new.process(sexp)
    end
  end

  def test_logical_group_with_condition
    target = "interaction.content"
    operator = "=="
    condition = %Q{#{target} #{operator} "baz"}
    condition_origin = s(:condition,
                         s(:target, target),
                         s(:operator, operator),
                         s(:argument,
                           s(:string, "baz")))
    expected = "v1"
    sexp = s(:logical_group,
             condition_origin)
    assert_csdl_equal(expected, sexp, { condition => "v1" }, { "v1" => condition_origin })
  end

  def test_not
    target = "interaction.content"
    operator = "=="
    condition = %Q{#{target} #{operator} "baz"}
    condition_origin = s(:condition,
                         s(:target, target),
                         s(:operator, operator),
                         s(:argument,
                           s(:string, "baz")))
    expected = "Not(v1)"
    sexp = s(:not,
             s(:target, target),
             s(:operator, operator),
             s(:argument,
               s(:string, "baz")))
    assert_csdl_equal(expected, sexp, { condition => "v1" }, { "v1" => condition_origin })
  end

  def test_not_with_logical_group
    target = "interaction.content"
    operator = "=="
    condition = %Q{#{target} #{operator} "baz"}
    expected = "Not(v1)"
    condition_origin = s(:condition,
                         s(:target, target),
                         s(:operator, operator),
                         s(:argument,
                           s(:string, "baz")))
    sexp = s(:not,
             s(:logical_group,
               condition_origin))
    assert_csdl_equal(expected, sexp, { condition => "v1" }, { "v1" => condition_origin })
  end

  def test_operator
    operator = ::CSDL::OPERATORS.keys.sample
    sexp = s(:operator, operator)
    assert_csdl_equal(operator, sexp, {}, {})
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
    conditions = { "fb.content contains \"foo\"" => "v1",
                   "fb.content contains \"bar\"" => "v2" }
    conditions_origins =
      {
        "v1" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "foo"))),
        "v2" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "bar")))
      }
    expected = "Or(v1,v2)"
    sexp = s(:or,
             conditions_origins["v1"],
             conditions_origins["v2"])
    assert_csdl_equal(expected, sexp, conditions, conditions_origins)
  end

  def test_or_with_3_children
    conditions = { "fb.content contains \"foo\"" => "v1",
                  "fb.content contains \"bar\"" => "v2",
                  "fb.content contains \"baz\"" => "v3" }
    conditions_origins =
      {
        "v1" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "foo"))),
        "v2" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "bar"))),
        "v3" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "baz")))
      }
    expected = "Or(v1,v2,v3)"
    sexp = s(:or,
             conditions_origins["v1"],
             conditions_origins["v2"],
             conditions_origins["v3"])
    assert_csdl_equal(expected, sexp, conditions)
  end

  def test_string_with_quotes
    ::CSDL::Processor.any_instance.expects(:on_string).with(s(:string, "arg")).returns("result")
    expected = "result"
    sexp = s(:string, "arg")
    assert_csdl_equal(expected, sexp, {}, {})
  end

  def test_target
    ::CSDL::Processor.any_instance.expects(:on_target).with(s(:target, "arg")).returns("result")
    expected = "result"
    sexp = s(:target, "arg")
    assert_csdl_equal(expected, sexp, {}, {})
  end

  def test_condition
    target = "interaction.content"
    operator = "=="
    condition = %Q{#{target} #{operator} "baz"}
    expected = "v1"
    sexp = s(:condition,
             s(:target, target),
             s(:operator, operator),
             s(:argument,
               s(:string, "baz")))
    assert_csdl_equal(expected, sexp, { condition => "v1" }, { "v1" => sexp })
  end

  def test_grouped_expressions
    conditions = { 'fb.content contains "foo"' => "v1",
                   'fb.parent.content contains "foo"' => "v2",
                   'fb.content contains "bar"' => "v3",
                   'fb.parent.content contains "bar"' => "v4" }
    conditions_origins =
      {
        "v1" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "foo"))),
        "v2" => s(:condition,
                  s(:target, "fb.parent.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "foo"))),
        "v3" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "bar"))),
        "v4" => s(:condition,
                  s(:target, "fb.parent.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "bar")))
      }
    expected = "And(Or(v1,v2),Or(v3,v4))"
    sexp = \
      s(:and,
        s(:logical_group,
          s(:or,
            conditions_origins["v1"],
            conditions_origins["v2"])),
        s(:logical_group,
           s(:or,
            conditions_origins["v3"],
            conditions_origins["v4"])))

    assert_csdl_equal(expected, sexp, conditions, conditions_origins)
  end

  def test_raw
    raw = %q{fb.content contains_any "foo" OR fb.parent.content contains_any "foo"}
    sexp = s(:raw, raw)
    expected = "v1"
    assert_csdl_equal(expected, sexp, { raw => "v1" }, { "v1" => sexp })
  end

  def test_raw_grouped_with_other_conditions
    conditions = { "fb.type exists" => "v1",
                   'fb.content contains_any "foo" OR fb.parent.content contains_any "foo"' => "v2" }
    conditions_origins =
      {
        "v1" => s(:condition,
                  s(:target, "fb.type"),
                  s(:operator, :exists)),
        "v2" => s(:raw, %q{fb.content contains_any "foo" OR fb.parent.content contains_any "foo"})
      }
    expected = "Or(v1,v2)"
    sexp = s(:or,
             conditions_origins["v1"],
             s(:logical_group,
               conditions_origins["v2"]))

    assert_csdl_equal(expected, sexp, conditions, conditions_origins)
  end

  def test_contains_any_becomes_group_of_contains_ored
    conditions = { "fb.content contains \"foo\"" => "v1",
                  "fb.content contains \"bar\"" => "v2",
                  "fb.content contains \"baz\"" => "v3" }
    conditions_origins =
      {
        "v1" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "foo"))),
        "v2" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "bar"))),
        "v3" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "baz")))
      }
    expected = "Or(v1,v2,v3)"
    sexp = s(:condition,
             s(:target, "fb.content"),
             s(:operator, :contains_any),
             s(:argument,
               s(:string, "foo,bar,baz")))
    assert_csdl_equal(expected, sexp, conditions, conditions_origins)
  end

  def test_contains_any_with_one_word_becomes_contains
    conditions = { "fb.content contains \"foo\"" => "v1" }
    conditions_origins =
      {
        "v1" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "foo")))
      }
    expected = "v1"
    sexp = s(:condition,
             s(:target, "fb.content"),
             s(:operator, :contains_any),
             s(:argument,
               s(:string, "foo")))
    assert_csdl_equal(expected, sexp, conditions, conditions_origins)
  end

  def test_contains_all_becomes_group_of_contains_ored
    conditions = { "fb.content contains \"foo\"" => "v1",
                   "fb.content contains \"bar\"" => "v2",
                   "fb.content contains \"baz\"" => "v3" }
    conditions_origins =
      {
        "v1" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "foo"))),
        "v2" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "bar"))),
        "v3" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "baz")))
      }
    expected = "And(v1,v2,v3)"
    sexp = s(:condition,
             s(:target, "fb.content"),
             s(:operator, :contains_all),
             s(:argument,
               s(:string, "foo,bar,baz")))
    assert_csdl_equal(expected, sexp, conditions, conditions_origins)
  end

  def test_contains_all_with_one_word_becomes_contains
    conditions = { "fb.content contains \"foo\"" => "v1" }
    conditions_origins =
      {
        "v1" => s(:condition,
                  s(:target, "fb.content"),
                  s(:operator, :contains),
                  s(:argument,
                    s(:string, "foo")))
      }
    expected = "v1"
    sexp = s(:condition,
             s(:target, "fb.content"),
             s(:operator, :contains_all),
             s(:argument,
               s(:string, "foo")))
    assert_csdl_equal(expected, sexp, conditions, conditions_origins)
  end

  private

  def assert_csdl_equal(expected, sexp, conditions = nil, conditions_origins = nil)
    processor = ::CSDL::BooleanProcessor.new
    assert_equal(expected, processor.process(sexp))
    assert_equal(conditions, processor.conditions) if conditions
    assert_equal(conditions_origins, processor.conditions_origins) if conditions_origins
  end
end
