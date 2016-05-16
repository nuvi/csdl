require "test_helper"

class OptimizingProcessorTest < ::MiniTest::Test
  include ::AST::Sexp

  def test_converts_multiple_anded_contains_into_contains_all
    sexp = s(:and,
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:condition,
               s(:target, "interaction.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:condition,
               s(:target, "tumblr.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "cat"))),
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))),
             s(:condition,
               s(:target, "interaction.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))))
    expected = s(:and,
                 s(:condition,
                   s(:target, "fb.content"),
                   s(:operator, :contains_all),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:condition,
                   s(:target, "interaction.content"),
                   s(:operator, :contains_all),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:condition,
                   s(:target, "tumblr.content"),
                   s(:operator, :contains),
                   s(:argument,
                     s(:string, "cat"))))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_converts_multiple_anded_not_contains_into_not_contains_any
    sexp = s(:and,
             s(:not,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:not,
               s(:target, "interaction.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:not,
               s(:target, "tumblr.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "cat"))),
             s(:not,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))),
             s(:not,
               s(:target, "interaction.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))))
    expected = s(:and,
                 s(:not,
                   s(:target, "fb.content"),
                   s(:operator, :contains_any),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:not,
                   s(:target, "interaction.content"),
                   s(:operator, :contains_any),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:not,
                   s(:target, "tumblr.content"),
                   s(:operator, :contains),
                   s(:argument,
                     s(:string, "cat"))))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_converts_multiple_ored_contains_into_contains_any
    sexp = s(:or,
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:condition,
               s(:target, "interaction.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:condition,
               s(:target, "tumblr.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "cat"))),
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))),
             s(:condition,
               s(:target, "interaction.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))))
    expected = s(:or,
                 s(:condition,
                   s(:target, "fb.content"),
                   s(:operator, :contains_any),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:condition,
                   s(:target, "interaction.content"),
                   s(:operator, :contains_any),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:condition,
                   s(:target, "tumblr.content"),
                   s(:operator, :contains),
                   s(:argument,
                     s(:string, "cat"))))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_converts_multiple_ored_not_contains_into_not_contains_all
    sexp = s(:or,
             s(:not,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:not,
               s(:target, "interaction.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:not,
               s(:target, "tumblr.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "cat"))),
             s(:not,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))),
             s(:not,
               s(:target, "interaction.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))))
    expected = s(:or,
                 s(:not,
                   s(:target, "fb.content"),
                   s(:operator, :contains_all),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:not,
                   s(:target, "interaction.content"),
                   s(:operator, :contains_all),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:not,
                   s(:target, "tumblr.content"),
                   s(:operator, :contains),
                   s(:argument,
                     s(:string, "cat"))))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_collapses_and_into_condition
    sexp = s(:and,
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))))
    expected = s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains),
                 s(:argument,
                   s(:string, "apple")))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_collapses_logical_group_into_condition
    sexp = s(:logical_group,
             s(:and,
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains),
                 s(:argument,
                   s(:string, "apple"))),
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains),
                 s(:argument,
                   s(:string, "apple")))))
    expected = s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains),
                 s(:argument,
                   s(:string, "apple")))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_collapses_logical_group_with_not_into_not
    sexp = s(:not,
             s(:logical_group,
               s(:and,
                 s(:condition,
                   s(:target, "fb.content"),
                   s(:operator, :contains),
                   s(:argument,
                     s(:string, "apple"))),
                 s(:condition,
                   s(:target, "fb.content"),
                   s(:operator, :contains),
                   s(:argument,
                     s(:string, "apple"))))))
    expected = s(:not,
                 s(:target, "fb.content"),
                 s(:operator, :contains),
                 s(:argument,
                   s(:string, "apple")))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_doesnt_group_contains_any_with_and
    sexp = s(:logical_group,
             s(:and,
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_any),
                 s(:argument,
                   s(:string, "apple,book"))),
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_any),
                 s(:argument,
                   s(:string, "cat,eye")))))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(sexp, actual)
  end

  def test_doesnt_group_contains_any_and_contains_with_and
    sexp = s(:logical_group,
             s(:and,
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_any),
                 s(:argument,
                   s(:string, "apple,book"))),
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains),
                 s(:argument,
                   s(:string, "cat")))))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(sexp, actual)
  end

  def test_groups_contains_any_with_or
    sexp = s(:logical_group,
             s(:or,
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_any),
                 s(:argument,
                   s(:string, "apple,book"))),
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_any),
                 s(:argument,
                   s(:string, "cat,eye")))))
    expected = s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_any),
                 s(:argument,
                   s(:string, "apple,book,cat,eye")))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_groups_contains_any_and_contains_with_or
    sexp = s(:logical_group,
             s(:or,
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_any),
                 s(:argument,
                   s(:string, "apple,book"))),
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains),
                 s(:argument,
                   s(:string, "cat")))))
    expected = s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_any),
                 s(:argument,
                   s(:string, "apple,book,cat")))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_doesnt_group_contains_all_with_or
    sexp = s(:logical_group,
             s(:or,
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_all),
                 s(:argument,
                   s(:string, "apple,book"))),
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_all),
                 s(:argument,
                   s(:string, "cat,eye")))))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(sexp, actual)
  end

  def test_doesnt_group_contains_all_and_contains_with_or
    sexp = s(:logical_group,
             s(:or,
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_all),
                 s(:argument,
                   s(:string, "apple,book"))),
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains),
                 s(:argument,
                   s(:string, "cat")))))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(sexp, actual)
  end

  def test_groups_contains_all_with_and
    sexp = s(:logical_group,
             s(:and,
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_all),
                 s(:argument,
                   s(:string, "apple,book"))),
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_all),
                 s(:argument,
                   s(:string, "cat,eye")))))
    expected = s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_all),
                 s(:argument,
                   s(:string, "apple,book,cat,eye")))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_groups_contains_all_and_contains_with_and
    sexp = s(:logical_group,
             s(:and,
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_all),
                 s(:argument,
                   s(:string, "apple,book"))),
               s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains),
                 s(:argument,
                   s(:string, "cat")))))
    expected = s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_all),
                 s(:argument,
                   s(:string, "apple,book,cat")))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_reuses_collapsed_result_with_not
    sexp = s(:and,
             s(:not,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))),
             s(:not,
               s(:logical_group,
                 s(:and,
                   s(:condition,
                     s(:target, "fb.content"),
                     s(:operator, :contains),
                     s(:argument,
                       s(:string, "apple"))),
                   s(:condition,
                     s(:target, "fb.content"),
                     s(:operator, :contains),
                     s(:argument,
                       s(:string, "apple")))))))
    expected = s(:not,
                 s(:target, "fb.content"),
                 s(:operator, :contains_any),
                 s(:argument,
                   s(:string, "apple,book")))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_reuses_collapsed_result_with_condition
    sexp = s(:and,
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))),
             s(:logical_group,
               s(:and,
                 s(:condition,
                   s(:target, "fb.content"),
                   s(:operator, :contains),
                   s(:argument,
                     s(:string, "apple"))),
                 s(:condition,
                   s(:target, "fb.content"),
                   s(:operator, :contains),
                   s(:argument,
                     s(:string, "cat"))))))
    expected = s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains_all),
                 s(:argument,
                   s(:string, "apple,book,cat")))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_keeps_other_operators
    sexp = s(:or,
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, "=="),
               s(:argument,
                 s(:string, "book"))))
    expected = s(:or,
                 s(:condition,
                   s(:target, "fb.content"),
                   s(:operator, "=="),
                   s(:argument,
                     s(:string, "book"))),
                 s(:condition,
                   s(:target, "fb.content"),
                   s(:operator, :contains),
                   s(:argument,
                     s(:string, "apple"))))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end
end
