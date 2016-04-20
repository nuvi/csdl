require "test_helper"

class BuilderTest < ::MiniTest::Test
  include ::AST::Sexp

  def test_optimize_complexly
    expected = s(:logical_group,
                 s(:or,
                   s(:not,
                     s(:target, "fb.content"),
                     s(:operator, :contains_any),
                     s(:argument,
                       s(:string, "apple,book"))),
                   s(:condition,
                     s(:target, "fb.content"),
                     s(:operator, :contains_all),
                     s(:argument,
                       s(:string, "apple,book"))),
                   s(:logical_group,
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
                           s(:string, "book")))))))

    tree = CSDL::Builder.new.logical_group do
      _or do
        [
          logical_group do
            _and do
              [
                condition("fb.content", :contains, "apple"),
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
