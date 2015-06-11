require "test_helper"

class BuilderTest < ::MiniTest::Test
  include ::AST::Sexp

  def test_closure_0_children
    expected = s(:closure, nil)
    actual = ::CSDL::Builder.new.closure {}
    assert_equal(expected, actual)
  end

  def test_closure_1_child
    expected = s(:closure,
                 s(:where,
                  s(:target, "foo"),
                  s(:operator, "bar"),
                  s(:argument,
                    s(:string, "baz"))))

    actual = ::CSDL::Builder.new.closure do
      where("foo", "bar", "baz")
    end

    assert_equal(expected, actual)
  end

  def test_closure_2_children
    expected = s(:closure,
                 s(:where,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "first"))),
                 s(:where,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "second"))))

    actual = ::CSDL::Builder.new.closure do
      [
        where("this", "is", "first"),
        where("this", "is", "second")
      ]
    end

    assert_equal(expected, actual)
  end

  def test_or_0_children
    expected = s(:or, nil)
    actual = ::CSDL::Builder.new._or {}
    assert_equal(expected, actual)
  end

  def test_or_1_child
    expected = s(:or,
                 s(:where,
                  s(:target, "foo"),
                  s(:operator, "bar"),
                  s(:argument,
                    s(:string, "baz"))))

    actual = ::CSDL::Builder.new._or do
      where("foo", "bar", "baz")
    end

    assert_equal(expected, actual)
  end

  def test_or_2_children
    expected = s(:or,
                 s(:where,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "first"))),
                 s(:where,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "second"))))

    actual = ::CSDL::Builder.new._or do
      [
        where("this", "is", "first"),
        where("this", "is", "second")
      ]
    end

    assert_equal(expected, actual)
  end

  def test_and_0_children
    expected = s(:and, nil)
    actual = ::CSDL::Builder.new._and {}
    assert_equal(expected, actual)
  end

  def test_and_1_child
    expected = s(:and,
                 s(:where,
                  s(:target, "foo"),
                  s(:operator, "bar"),
                  s(:argument,
                    s(:string, "baz"))))

    actual = ::CSDL::Builder.new._and do
      where("foo", "bar", "baz")
    end

    assert_equal(expected, actual)
  end

  def test_and_2_children
    expected = s(:and,
                 s(:where,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "first"))),
                 s(:where,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "second"))))

    actual = ::CSDL::Builder.new._and do
      [
        where("this", "is", "first"),
        where("this", "is", "second")
      ]
    end

    assert_equal(expected, actual)
  end

  def test_where_with_argument
    expected = s(:where,
                 s(:target, "this"),
                 s(:operator, "is"),
                 s(:argument,
                   s(:string, "an argument")))

    actual = ::CSDL::Builder.new.where("this", "is", "an argument")

    assert_equal(expected, actual)
  end

  def test_where_without_argument
    expected = s(:where,
                 s(:target, "foo"),
                 s(:operator, "bar"))

    actual = ::CSDL::Builder.new.where("foo", "bar")

    assert_equal(expected, actual)
  end

# builder = CSDLBuilder.new._or do
#   [
#     closure {
#       _and {
#         [
#           closure {
#             _or {
#               [
#                 where("fb.content", :contains_any, "ebola"),
#                 where("fb.parent.content", :contains_any, "ebola")
#               ]
#             }
#           },
#           _not("fb.content", :contains_any, "government,politics"),
#           where("fb.author.country_code", :in, "GB")
#         ]
#       }
#     },
#     closure {
#       _and {
#         [
#           closure {
#             _or {
#               [
#                 where("fb.content", :contains_any, "malta,malta island,#malta"),
#                 where("fb.parent.content", :contains_any, "malta,malta island,#malta")
#               ]
#             }
#           },
#           _not("fb.content", :contains_any, "vacation,suicide,poker awards")
#         ]
#       }
#     }
#   ]
# end
#
# puts
# puts "Builder sexp..."
# puts builder.to_sexp
#
# puts
# puts "processing built sexp..."
# puts CSDL.new.process(builder)

end
