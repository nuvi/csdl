require "test_helper"

class OptimizerTest < ::MiniTest::Test
  include ::AST::Sexp

  def test_optimize_empty
    sexp = s(:root)
    expected = nil
    actual = CSDL::Optimizer.new.optimize(sexp)
    assert_equal(expected, actual)
  end

  def test_optimize_false_expression
    sexp = s(:and,
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:not,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))))
    expected = nil
    assert_raises(::CSDL::FalseExpressionError) do
      ::CSDL::Optimizer.new.optimize(sexp)
    end
  end

  def test_optimize_true_expression
    sexp = s(:or,
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:not,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))))
    expected = nil
    actual = ::CSDL::Optimizer.new.optimize(sexp)
    assert_equal(expected, actual)
  end

  def test_optimize_one_condition
    sexp = s(:condition,
             s(:target, "fb.content"),
             s(:operator, :contains),
             s(:argument,
               s(:string, "apple")))
    expected = sexp
    actual = ::CSDL::Optimizer.new.optimize(sexp)
    assert_equal(expected, actual)
  end

  def test_optimize_complexly
    expected = s(:or,
                 s(:and,
                   s(:not,
                     s(:target, "fb.content"),
                     s(:operator, :contains),
                     s(:argument,
                       s(:string, "book"))),
                   s(:condition,
                     s(:target, "fb.content"),
                     s(:operator, :contains),
                     s(:argument,
                       s(:string, "cat")))),
                 s(:not,
                   s(:target, "fb.content"),
                   s(:operator, :contains_any),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:condition,
                   s(:target, "fb.content"),
                   s(:operator, :contains_all),
                   s(:argument,
                     s(:string, "apple,book"))))

    tree = CSDL::Builder.new.logical_group do
      _or do
        [
          logical_group do
            _and do
              [
                _not("fb.content", :contains, "apple"),
                _not("fb.content", :contains, "book"),
                _not("fb.content", :contains, "cat"),
              ]
            end
          end,
          logical_group do
            _and do
              [
                _not("fb.content", :contains, "apple"),
                _not("fb.content", :contains, "book"),
                condition("fb.content", :contains, "cat"),
              ]
            end
          end,
          logical_group do
            _and do
              [
                condition("fb.content", :contains, "apple"),
                _not("fb.content", :contains, "book"),
                condition("fb.content", :contains, "cat"),
              ]
            end
          end,
          logical_group do
            _and do
              [
                condition("fb.content", :contains, "apple"),
                condition("fb.content", :contains, "book"),
                condition("fb.content", :contains, "cat"),
              ]
            end
          end,
          logical_group do
            _and do
              [
                condition("fb.content", :contains, "apple"),
                condition("fb.content", :contains, "book"),
                _not("fb.content", :contains, "cat"),
              ]
            end
          end
        ]
      end
    end

    actual = CSDL::Optimizer.new.optimize(tree)
    assert_equal(expected, actual)
  end
end
