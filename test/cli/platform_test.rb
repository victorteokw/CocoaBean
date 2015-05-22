require 'test_helper.rb'

class PlatformTest < CocoaBean::Test
  def setup
    @platform = CocoaBean::Platform.new(:web)
  end

  def teardown
    @platform = nil
  end

  test "to_s method should behave correctly" do
    s = @platform.to_s
    assert_match "#{@platform.name}", s
    assert_match "#{@platform.readable_name}", s
    assert_match "#{@platform.supported}", s
    assert_match "#{@platform.distribution_directory}", s
    assert_match "#{@platform.code_location}", s
  end

end
