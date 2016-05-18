require "test_helper"

class BuilderTest < ::MiniTest::Test
  include ::AST::Sexp

  def test_root_0_children
    expected = nil
    actual = ::CSDL::Builder.new.root {}
    assert_equal(expected, actual)
  end

  def test_root_1_child
    expected = s(:root,
                 s(:condition,
                  s(:target, "foo"),
                  s(:operator, "bar"),
                  s(:argument,
                    s(:string, "baz"))))

    actual = ::CSDL::Builder.new.root do
      condition("foo", "bar", "baz")
    end

    assert_equal(expected, actual)
  end

  def test_root_2_children
    expected = s(:root,
                 s(:condition,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "first"))),
                 s(:condition,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "second"))))

    actual = ::CSDL::Builder.new.root do
      [
        condition("this", "is", "first"),
        condition("this", "is", "second")
      ]
    end

    assert_equal(expected, actual)
  end

  def test_root_with_tags_and_return_statement
    expected = s(:root,
                 s(:tag,
                   s(:tag_namespaces,
                     s(:tag_namespace, "movies")),
                   s(:tag_class,
                     s(:string, "Video")),
                   s(:statement_scope,
                     s(:condition,
                       s(:target, "links.url"),
                       s(:operator, :any),
                       s(:argument,
                         s(:string, "youtube.com,vimeo.com"))))),
                 s(:tag,
                   s(:tag_namespaces,
                     s(:tag_namespace, "movies")),
                   s(:tag_class,
                     s(:string, "Social Networks")),
                   s(:statement_scope,
                     s(:condition,
                       s(:target, "links.url"),
                       s(:operator, :any),
                       s(:argument,
                         s(:string, "twitter.com,facebook.com"))))),
                 s(:return,
                   s(:statement_scope,
                     s(:or,
                       s(:condition,
                         s(:target, "fb.topics.category"),
                         s(:operator, :in),
                         s(:argument,
                           s(:string, "Movie,Film,TV"))),
                       s(:condition,
                         s(:target, "fb.parent.topics.category"),
                         s(:operator, :in),
                         s(:argument,
                           s(:string, "Movie,Film,TV")))))))

    actual = CSDL::Builder.new.root do
      [
        tag_tree(["movies"], "Video") {
          condition("links.url", :any, "youtube.com,vimeo.com")
        },

        tag_tree(["movies"], "Social Networks") {
          condition("links.url", :any, "twitter.com,facebook.com")
        },

        _return {
          _or {
            [
              condition("fb.topics.category", :in, "Movie,Film,TV"),
              condition("fb.parent.topics.category", :in, "Movie,Film,TV")
            ]
          }
        }
      ]
    end

    assert_equal(expected, actual)
  end

  def test_statement_scope_0_children
    expected = nil
    actual = ::CSDL::Builder.new.statement_scope {}
    assert_equal(expected, actual)
  end

  def test_statement_scope_1_child
    expected = s(:statement_scope,
                 s(:condition,
                  s(:target, "foo"),
                  s(:operator, "bar"),
                  s(:argument,
                    s(:string, "baz"))))

    actual = ::CSDL::Builder.new.statement_scope do
      condition("foo", "bar", "baz")
    end

    assert_equal(expected, actual)
  end

  def test_statement_scope_2_children
    expected = s(:statement_scope,
                 s(:condition,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "first"))),
                 s(:condition,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "second"))))

    actual = ::CSDL::Builder.new.statement_scope do
      [
        condition("this", "is", "first"),
        condition("this", "is", "second")
      ]
    end

    assert_equal(expected, actual)
  end

  def test_logical_group_0_children
    expected = nil
    actual = ::CSDL::Builder.new.logical_group {}
    assert_equal(expected, actual)
  end

  def test_logical_group_1_child
    expected = s(:logical_group,
                 s(:condition,
                  s(:target, "foo"),
                  s(:operator, "bar"),
                  s(:argument,
                    s(:string, "baz"))))

    actual = ::CSDL::Builder.new.logical_group do
      condition("foo", "bar", "baz")
    end

    assert_equal(expected, actual)
  end

  def test_logical_group_2_children
    expected = s(:logical_group,
                 s(:condition,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "first"))),
                 s(:condition,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "second"))))

    actual = ::CSDL::Builder.new.logical_group do
      [
        condition("this", "is", "first"),
        condition("this", "is", "second")
      ]
    end

    assert_equal(expected, actual)
  end

  def test_or_0_children
    expected = nil
    actual = ::CSDL::Builder.new._or {}
    assert_equal(expected, actual)
  end

  def test_or_1_child_does_not_wrap_in_or_node
    expected = s(:condition,
                 s(:target, "foo"),
                 s(:operator, "bar"),
                 s(:argument,
                   s(:string, "baz")))

    actual = ::CSDL::Builder.new._or do
      condition("foo", "bar", "baz")
    end

    assert_equal(expected, actual)
  end

  def test_or_2_children
    expected = s(:or,
                 s(:condition,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "first"))),
                 s(:condition,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "second"))))

    actual = ::CSDL::Builder.new._or do
      [
        condition("this", "is", "first"),
        condition("this", "is", "second")
      ]
    end

    assert_equal(expected, actual)
  end

  def test_or_logical_group_0_children
    expected = nil
    actual = ::CSDL::Builder.new.logical_group(:or) {}
    assert_equal(expected, actual)
  end

  def test_or_logical_group_1_child
    expected = s(:logical_group,
                   s(:condition,
                     s(:target, "this"),
                     s(:operator, "is"),
                     s(:argument,
                       s(:string, "first"))))

    actual = ::CSDL::Builder.new.logical_group(:or) do
      condition("this", "is", "first")
    end

    assert_equal(expected, actual)
  end

  def test_or_logical_group
    expected = s(:logical_group,
                 s(:or,
                   s(:condition,
                     s(:target, "this"),
                     s(:operator, "is"),
                     s(:argument,
                       s(:string, "first"))),
                   s(:condition,
                     s(:target, "this"),
                     s(:operator, "is"),
                     s(:argument,
                       s(:string, "second")))))

    actual = ::CSDL::Builder.new.logical_group(:or) do
      [
        condition("this", "is", "first"),
        condition("this", "is", "second")
      ]
    end

    assert_equal(expected, actual)
  end

  def test_and_0_children
    expected = nil
    actual = ::CSDL::Builder.new._and {}
    assert_equal(expected, actual)
  end

  def test_and_1_child_does_not_wrap_in_and_node
    expected = s(:condition,
                 s(:target, "foo"),
                 s(:operator, "bar"),
                 s(:argument,
                   s(:string, "baz")))

    actual = ::CSDL::Builder.new._and do
      condition("foo", "bar", "baz")
    end

    assert_equal(expected, actual)
  end

  def test_and_2_children
    expected = s(:and,
                 s(:condition,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "first"))),
                 s(:condition,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "second"))))

    actual = ::CSDL::Builder.new._and do
      [
        condition("this", "is", "first"),
        condition("this", "is", "second")
      ]
    end

    assert_equal(expected, actual)
  end

  def test_and_logical_group
    expected = s(:logical_group,
                 s(:and,
                   s(:condition,
                     s(:target, "this"),
                     s(:operator, "is"),
                     s(:argument,
                       s(:string, "first"))),
                   s(:condition,
                     s(:target, "this"),
                     s(:operator, "is"),
                     s(:argument,
                       s(:string, "second")))))

    actual = ::CSDL::Builder.new.logical_group(:and) do
      [
        condition("this", "is", "first"),
        condition("this", "is", "second")
      ]
    end

    assert_equal(expected, actual)
  end

  def test_and_logical_group_0_children
    expected = nil
    actual = ::CSDL::Builder.new.logical_group(:and) {}

    assert_equal(expected, actual)
  end

  def test_and_logical_group_1_child
    expected = s(:logical_group,
                 s(:condition,
                   s(:target, "this"),
                   s(:operator, "is"),
                   s(:argument,
                     s(:string, "first"))))

    actual = ::CSDL::Builder.new.logical_group(:and) do
      condition("this", "is", "first")
    end

    assert_equal(expected, actual)
  end

  def test_condition_with_argument
    expected = s(:condition,
                 s(:target, "this"),
                 s(:operator, "is"),
                 s(:argument,
                   s(:string, "an argument")))

    actual = ::CSDL::Builder.new.condition("this", "is", "an argument")

    assert_equal(expected, actual)
  end

  def test_condition_without_argument
    expected = s(:condition,
                 s(:target, "foo"),
                 s(:operator, "bar"))

    actual = ::CSDL::Builder.new.condition("foo", "bar")

    assert_equal(expected, actual)
  end

  def test_not_with_argument
    expected = s(:not,
                 s(:target, "this"),
                 s(:operator, "is"),
                 s(:argument,
                   s(:string, "an argument")))

    actual = ::CSDL::Builder.new._not("this", "is", "an argument")

    assert_equal(expected, actual)
  end

  def test_not_with_condition
    expected = s(:not,
                 s(:target, "foo"),
                 s(:operator, "bar"))

    actual = ::CSDL::Builder.new._not do
      condition("foo", "bar")
    end

    assert_equal(expected, actual)
  end

  def test_not_with_logical_group
    expected = s(:not,
                 s(:logical_group,
                   s(:and,
                     s(:condition,
                       s(:target, "this"),
                       s(:operator, "is"),
                       s(:argument,
                         s(:string, "first"))),
                     s(:condition,
                       s(:target, "this"),
                       s(:operator, "is"),
                       s(:argument,
                         s(:string, "second"))))))

    actual = ::CSDL::Builder.new._not do
      logical_group(:and) do
        [
          condition("this", "is", "first"),
          condition("this", "is", "second")
        ]
      end
    end

    assert_equal(expected, actual)
  end

  def test_not_without_argument
    expected = s(:not,
                 s(:target, "foo"),
                 s(:operator, "bar"))

    actual = ::CSDL::Builder.new._not("foo", "bar")

    assert_equal(expected, actual)
  end

  def test_raw
    expected = s(:raw, %q{fb.content contains_any "foo" OR fb.parent.content contains_any "foo"})
    actual = ::CSDL::Builder.new.raw(%q{fb.content contains_any "foo" OR fb.parent.content contains_any "foo"})

    assert_equal(expected, actual)
  end

  def test_raw_combined_with_ast_nodes
    expected = s(:or,
                 s(:condition,
                   s(:target, "fb.type"),
                   s(:operator, :exists)),
                 s(:logical_group,
                   s(:raw, %q{fb.content contains_any "foo" OR fb.parent.content contains_any "foo"})))

    actual = ::CSDL::Builder.new._or do
      [
        condition("fb.type", :exists),
        logical_group { raw(%q{fb.content contains_any "foo" OR fb.parent.content contains_any "foo"}) }
      ]
    end

    assert_equal(expected, actual)
  end

  def test_return
    expected = s(:return,
                 s(:statement_scope,
                   s(:condition,
                     s(:target, "foo"),
                     s(:operator, "bar"))))

    actual = ::CSDL::Builder.new._return do
      condition("foo", "bar")
    end

    assert_equal(expected, actual)
  end

  def test_tag
    expected = s(:tag,
                 s(:tag_class,
                   s(:string, "MyTag")),
                 s(:statement_scope,
                   s(:condition,
                     s(:target, "foo"),
                     s(:operator, "bar"))))

    actual = ::CSDL::Builder.new.tag("MyTag") do
      condition("foo", "bar")
    end

    assert_equal(expected, actual)
  end

  def test_tag_tree
    expected = s(:tag,
                 s(:tag_namespaces,
                   s(:tag_namespace, "foo"),
                   s(:tag_namespace, "bar")),
                 s(:tag_class,
                   s(:string, "MyTag")),
                 s(:statement_scope,
                   s(:condition,
                     s(:target, "baz"),
                     s(:operator, "quux"))))

    actual = ::CSDL::Builder.new.tag_tree(["foo", "bar"], "MyTag") do
      condition("baz", "quux")
    end

    assert_equal(expected, actual)
  end

end
