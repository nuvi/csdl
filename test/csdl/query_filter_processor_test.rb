require "test_helper"

class QueryFilterProcessorTest < ::MiniTest::Test
  include ::AST::Sexp

  def test_valid_query_targets
    ::CSDL::QUERY_TARGETS.keys.each do |target_name|
      assert(::CSDL::QueryFilterProcessor.new.process(s(:target, target_name)))
    end
  end

  def test_invalid_query_target_raises
    assert_raises(::CSDL::InvalidQueryTargetError) do
      invalid_target = ::CSDL::TARGETS.values.find { |target| ! target.query? }
      ::CSDL::QueryFilterProcessor.new.process(s(:target, invalid_target.name))
    end
  end

  def test_valid_tag_tree_target
    assert(CSDL::QueryFilterProcessor.new.process(s(:target, "interaction.tag_tree.foo")))
  end

end


