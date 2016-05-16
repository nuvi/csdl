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

  def test_on_return_with_optimization
    expected = %q{return {interaction.content contains_all "apple,book"}}
    sexp = s(:return,
             s(:statement_scope,
               s(:and,
                 s(:condition,
                   s(:target, "interaction.content"),
                   s(:operator, "contains"),
                   s(:argument,
                     s(:string, "apple"))),
                 s(:condition,
                   s(:target, "interaction.content"),
                   s(:operator, "contains"),
                   s(:argument,
                     s(:string, "book"))))))
    assert_csdl_equal(expected, sexp, true)
  end

  def test_root_with_tags_and_return_statement
    expected = 'tag.movies "Video" {links.url any "youtube.com,vimeo.com"} tag.movies "Social Networks" {links.url any "twitter.com,facebook.com"} return {fb.topics.category in "Movie,Film,TV" OR fb.parent.topics.category in "Movie,Film,TV"}'
    sexp = s(:root,
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

    assert_csdl_equal(expected, sexp)
  end

  def test_root_with_tags_and_return_statement_with_optimization
    expected = 'tag.movies "Video" {links.url contains_any "vimeo.com,youtube.com"} tag.movies "Social Networks" {links.url contains_all "facebook.com,twitter.com"} return {fb.parent.topics.category in "Movie,Film,TV" OR fb.topics.category contains_any "Film,Movie,TV"}'
    sexp = s(:root,
                 s(:tag,
                   s(:tag_namespaces,
                     s(:tag_namespace, "movies")),
                   s(:tag_class,
                     s(:string, "Video")),
                   s(:statement_scope,
                     s(:or,
                       s(:condition,
                         s(:target, "links.url"),
                         s(:operator, :contains),
                         s(:argument,
                           s(:string, "youtube.com"))),
                       s(:condition,
                         s(:target, "links.url"),
                         s(:operator, :contains),
                         s(:argument,
                           s(:string, "vimeo.com")))))),
                 s(:tag,
                   s(:tag_namespaces,
                     s(:tag_namespace, "movies")),
                   s(:tag_class,
                     s(:string, "Social Networks")),
                   s(:statement_scope,
                     s(:and,
                       s(:condition,
                         s(:target, "links.url"),
                         s(:operator, :contains),
                         s(:argument,
                           s(:string, "twitter.com"))),
                       s(:condition,
                         s(:target, "links.url"),
                         s(:operator, :contains),
                         s(:argument,
                           s(:string, "facebook.com")))))),
                 s(:return,
                   s(:statement_scope,
                     s(:or,
                       s(:condition,
                         s(:target, "fb.topics.category"),
                         s(:operator, :contains),
                         s(:argument,
                           s(:string, "Movie"))),
                       s(:condition,
                         s(:target, "fb.topics.category"),
                         s(:operator, :contains),
                         s(:argument,
                           s(:string, "Film"))),
                       s(:condition,
                         s(:target, "fb.topics.category"),
                         s(:operator, :contains),
                         s(:argument,
                           s(:string, "TV"))),
                       s(:condition,
                         s(:target, "fb.parent.topics.category"),
                         s(:operator, :in),
                         s(:argument,
                           s(:string, "Movie,Film,TV")))))))

    assert_csdl_equal(expected, sexp, true)
  end

  def test_empty_on_statement_scope
    expected = "{}"
    sexp = s(:statement_scope)
    assert_csdl_equal(expected, sexp)
  end

  def test_empty_on_statement_scope_with_optimization
    expected = "{}"
    sexp = s(:statement_scope)
    assert_csdl_equal(expected, sexp, true)
  end

  def test_on_statement_scope_with_condition
    target = ::CSDL::INTERACTION_TARGETS.keys.sample
    operator = ::CSDL::OPERATORS.keys.sample
    expected = %Q{{#{target} #{operator} "baz"}}
    sexp = s(:statement_scope,
             s(:condition,
               s(:target, target),
               s(:operator, operator),
               s(:argument,
                 s(:string, "baz"))))
    assert_csdl_equal(expected, sexp)
  end

  def test_on_tag_class
    expected = %q{"MyTag"}
    sexp = s(:tag_class,
             s(:string, "MyTag"))
    assert_csdl_equal(expected, sexp)
  end

  def test_on_tag
    expected = %q{tag "MyTag" {"foo"}}
    sexp = s(:tag,
             s(:tag_class,
               s(:string, "MyTag")),
             s(:statement_scope,
               s(:string, "foo")))
    assert_csdl_equal(expected, sexp)
  end

  def test_on_tag_with_missing_tag_class
    assert_raises(::CSDL::MissingTagClassError) do
      sexp = s(:tag,
               s(:statement_scope,
                 s(:string, "foo")))
      ::CSDL::InteractionFilterProcessor.new.process(sexp)
    end
  end

  def test_on_tag_with_missing_statement_scope
    assert_raises(::CSDL::MissingTagStatementScopeError) do
      sexp = s(:tag,
               s(:tag_class,
                 s(:string, "foo")))
      ::CSDL::InteractionFilterProcessor.new.process(sexp)
    end
  end

  def test_on_tag_class
    expected = %q{"MyTag"}
    sexp = s(:tag_class,
             s(:string, "MyTag"))
    assert_csdl_equal(expected, sexp)
  end

  def test_on_tag_namespaces
    expected = %q{.foo.bar}
    sexp = s(:tag_namespaces,
             s(:tag_namespace, "foo"),
             s(:tag_namespace, "bar"))
    assert_csdl_equal(expected, sexp)
  end

  def test_on_tag_namespaces_without_tag_namespace_children
    assert_raises(::CSDL::MissingTagNodesError) do
      sexp = s(:tag_namespaces,
              s(:string, "foo"))
      ::CSDL::InteractionFilterProcessor.new.process(sexp)
    end
  end

  def test_on_tag_with_tree_nodes
    expected = %q{tag.foo.bar "MyTag" {"baz"}}
    sexp = s(:tag,
             s(:tag_namespaces,
               s(:tag_namespace, "foo"),
               s(:tag_namespace, "bar")),
             s(:tag_class,
               s(:string, "MyTag")),
             s(:statement_scope,
               s(:string, "baz")))
    assert_csdl_equal(expected, sexp)
  end

  def test_logical_groups_with_semioptimization
    sexp = s(:logical_group,
             s(:or,
               s(:logical_group,
                 s(:and,
                   s(:logical_group,
                     s(:or,
                       s(:condition,
                         s(:target, "instagram.type"),
                         s(:operator, "=="),
                         s(:argument,
                           s(:string, "image"))),
                       s(:condition,
                         s(:target, "tumblr.type"),
                         s(:operator, "!="),
                         s(:argument,
                           s(:string, ""))))),
                   s(:logical_group,
                     s(:or,
                       s(:condition,
                         s(:target, "interaction.content"),
                         s(:operator, "contains"),
                         s(:argument,
                           s(:string, "a"))),
                       s(:condition,
                         s(:target, "interaction.content"),
                         s(:operator, "contains"),
                         s(:argument,
                           s(:string, "b"))))))),
               s(:logical_group,
                 s(:and,
                   s(:logical_group,
                     s(:or,
                       s(:condition,
                         s(:target, "instagram.type"),
                         s(:operator, "=="),
                         s(:argument,
                           s(:string, "image"))),
                       s(:condition,
                         s(:target, "tumblr.type"),
                         s(:operator, "!="),
                         s(:argument,
                           s(:string, ""))))),
                   s(:logical_group,
                     s(:or,
                       s(:condition,
                         s(:target, "interaction.content"),
                         s(:operator, "contains"),
                         s(:argument,
                           s(:string, "c"))),
                       s(:condition,
                         s(:target, "interaction.content"),
                         s(:operator, "contains"),
                         s(:argument,
                           s(:string, "d")))))))))
    expected = "(((instagram.type == \"image\" OR tumblr.type != \"\") AND interaction.content contains_any \"a,b\") OR "\
               "((instagram.type == \"image\" OR tumblr.type != \"\") AND interaction.content contains_any \"c,d\"))"
    actual = CSDL::InteractionFilterProcessor.new(true, true).process(sexp)
    assert_equal(expected, actual)
  end

  private

  def assert_csdl_equal(expected, sexp, optimize = false)
    assert_equal(expected, ::CSDL::InteractionFilterProcessor.new(optimize).process(sexp))
  end

end

