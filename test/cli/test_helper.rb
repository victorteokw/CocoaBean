require 'minitest/autorun'
require File.expand_path('../../../lib/cocoa_bean.rb', __FILE__)
class Minitest::Test
  def silence_output
    $stdout = File.new( '/dev/null', 'w' )
    yield
  ensure
    $stdout = STDOUT
  end
end
