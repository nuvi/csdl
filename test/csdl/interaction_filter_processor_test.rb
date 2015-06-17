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

  def test_root_with_tags_and_return_statement
    expected = 'tag.movies "Video" {links.url any "youtube.com,vimeo.com"} tag.movies "Social Networks" {links.url any "twitter.com,facebook.com"} return {fb.topics.category in "Movie,Film,TV" OR fb.parent.topics.category in "Movie,Film,TV"}'
    sexp = s(:root,
                 s(:tag,
                   s(:tag_nodes,
                     s(:tag_node, "movies")),
                   s(:tag_class,
                     s(:string, "Video")),
                   s(:statement_scope,
                     s(:filter,
                       s(:target, "links.url"),
                       s(:operator, :any),
                       s(:argument,
                         s(:string, "youtube.com,vimeo.com"))))),
                 s(:tag,
                   s(:tag_nodes,
                     s(:tag_node, "movies")),
                   s(:tag_class,
                     s(:string, "Social Networks")),
                   s(:statement_scope,
                     s(:filter,
                       s(:target, "links.url"),
                       s(:operator, :any),
                       s(:argument,
                         s(:string, "twitter.com,facebook.com"))))),
                 s(:return,
                   s(:statement_scope,
                     s(:or,
                       s(:filter,
                         s(:target, "fb.topics.category"),
                         s(:operator, :in),
                         s(:argument,
                           s(:string, "Movie,Film,TV"))),
                       s(:filter,
                         s(:target, "fb.parent.topics.category"),
                         s(:operator, :in),
                         s(:argument,
                           s(:string, "Movie,Film,TV")))))))

    assert_csdl_equal(expected, sexp)
  end

  def test_empty_on_statement_scope
    expected = "{}"
    sexp = s(:statement_scope)
    assert_csdl_equal(expected, sexp)
  end

  def test_on_statement_scope_with_filter
    target = ::CSDL::TARGETS.keys.sample
    operator = ::CSDL::OPERATORS.keys.sample
    expected = %Q{{#{target} #{operator} "baz"}}
    sexp = s(:statement_scope,
             s(:filter,
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

  def test_on_tag_nodes
    expected = %q{.foo.bar}
    sexp = s(:tag_nodes,
             s(:tag_node, "foo"),
             s(:tag_node, "bar"))
    assert_csdl_equal(expected, sexp)
  end

  def test_on_tag_nodes_without_tag_node_children
    assert_raises(::CSDL::MissingTagNodesError) do
      sexp = s(:tag_nodes,
              s(:string, "foo"))
      ::CSDL::InteractionFilterProcessor.new.process(sexp)
    end
  end

  def test_on_tag_with_tree_nodes
    expected = %q{tag.foo.bar "MyTag" {"baz"}}
    sexp = s(:tag,
             s(:tag_nodes,
               s(:tag_node, "foo"),
               s(:tag_node, "bar")),
             s(:tag_class,
               s(:string, "MyTag")),
             s(:statement_scope,
               s(:string, "baz")))
    assert_csdl_equal(expected, sexp)
  end

  private

  def assert_csdl_equal(expected, sexp)
    assert_equal(expected, ::CSDL::InteractionFilterProcessor.new.process(sexp))
  end

end

