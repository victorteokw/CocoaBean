require 'test_helper.rb'

class TestExample < Minitest::Test
  def setup
    @a = "a"
  end

  def test_a
    assert_equal "a", @a
  end

  def test_equal
    assert_equal true, true
  end

  def test_not_nil
    refute_nil CocoaBean
  end
end
