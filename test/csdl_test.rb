require 'test_helper'

class CSDLTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::CSDL::VERSION
  end
end
