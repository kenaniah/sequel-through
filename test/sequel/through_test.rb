require "test_helper"

class Sequel::ThroughTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Sequel::Through::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
