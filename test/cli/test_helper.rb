require 'minitest/autorun'
require 'active_support'
require 'active_support/test_case'

require File.expand_path('../../../lib/cocoa_bean.rb', __FILE__)

class Minitest::Test
  def silence_output
    $stdout = File.new( '/dev/null', 'w' )
    yield
  ensure
    $stdout = STDOUT
  end
end

ActiveSupport::TestCase.test_order = :random

class CocoaBean::Test < ActiveSupport::TestCase
end
