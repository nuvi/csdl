require "test_helper"

class ProcessorTest < ::MiniTest::Test

  def test_binary_and
    expected = %q{"foo" AND "bar"}
    sexp = s(:and,
            s(:string, "foo"),
            s(:string, "bar"))
    assert_csdl_matches(expected, sexp)
  end

  def test_multi_and
    expected = %q{"foo" AND "bar" AND "baz"}
    sexp = s(:and,
            s(:string, "foo"),
            s(:string, "bar"),
            s(:string, "baz"))
    assert_csdl_matches(expected, sexp)
  end

  def test_argument
    expected = %q{"foo"}
    sexp = s(:argument,
             s(:string, "foo"))
    assert_csdl_matches(expected, sexp)
  end

  def test_multiple_argument_children
    expected = %q{"foo"}
    sexp = s(:argument,
             s(:string, "foo"),
             s(:string, "bar"))
    assert_csdl_matches(expected, sexp)
  end

  def test_empty_closure
    expected = "()"
    sexp = s(:closure)
    assert_csdl_matches(expected, sexp)
  end

  def test_closure_with_where
    expected = %q{(foo bar "baz")}
    sexp = s(:closure,
             s(:where,
               s(:target, "foo"),
               s(:operator, "bar"),
               s(:argument,
                 s(:string, "baz"))))
    assert_csdl_matches(expected, sexp)
  end

  def test_not
    expected = %q{NOT foo bar "baz"}
    sexp = s(:not,
             s(:target, "foo"),
             s(:operator, "bar"),
             s(:argument,
               s(:string, "baz")))
    assert_csdl_matches(expected, sexp)
  end

  def test_unary_or
    assert_raises(::CSDL::ASTError) do
      sexp = s(:or,
               s(:string, "foo"))
      ::CSDL::Processor.new.process(sexp)
    end
  end

  def test_binary_or
    expected = %q{"foo" OR "bar"}
    sexp = s(:or,
            s(:string, "foo"),
            s(:string, "bar"))
    assert_csdl_matches(expected, sexp)
  end

  def test_multi_or
    expected = %q{"foo" OR "bar" OR "baz"}
    sexp = s(:or,
            s(:string, "foo"),
            s(:string, "bar"),
            s(:string, "baz"))
    assert_csdl_matches(expected, sexp)
  end

  def test_string_with_quotes
    expected = '"this string has \"quotes\""'
    sexp = s(:string, 'this string has "quotes"')
    assert_csdl_matches(expected, sexp)
  end

  def test_target
    expected = "123"
    sexp = s(:target, 123)
    assert_csdl_matches(expected, sexp)
  end

  def test_where
    expected = %q{foo bar "baz"}
    sexp = s(:where,
             s(:target, "foo"),
             s(:operator, "bar"),
             s(:argument,
               s(:string, "baz")))
    assert_csdl_matches(expected, sexp)
  end

  def test_grouped_expressions
    expected = %q{(fb.content contains_any "foo" OR fb.parent.content contains_any "foo") AND (fb.content contains_any "bar" OR fb.parent.content contains_any "bar")}
    sexp = \
      s(:and,
        s(:closure,
          s(:or,
            s(:where,
              s(:target, "fb.content"),
              s(:operator, :contains_any),
              s(:argument,
                s(:string, "foo")
               )
             ),
             s(:where,
               s(:target, "fb.parent.content"),
               s(:operator, :contains_any),
               s(:argument,
                 s(:string, "foo")
                )
              ),
           ),
         ),
         s(:closure,
           s(:or,
             s(:where,
               s(:target, "fb.content"),
               s(:operator, :contains_any),
               s(:argument,
                 s(:string, "bar")
                )
              ),
              s(:where,
                s(:target, "fb.parent.content"),
                s(:operator, :contains_any),
                s(:argument,
                  s(:string, "bar")
                 )
               ),
            )
          )
       )

    assert_csdl_matches(expected, sexp)
  end

  private

  def assert_csdl_matches(expected, sexp)
    assert_equal(expected, ::CSDL::Processor.new.process(sexp))
  end

end
