require 'test_helper.rb'

class PlatformTest < Minitest::Test
  def setup
    @platform = CocoaBean::Platform.new(:web)
  end

  def teardown
    @platform = nil
  end

  def test_to_s
    s = @platform.to_s
    assert_match "#{@platform.name}", s
    assert_match "#{@platform.readable_name}", s
    assert_match "#{@platform.supported}", s
    assert_match "#{@platform.distribution_directory}", s
    assert_match "#{@platform.code_location}", s
  end

end
