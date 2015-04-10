# coding: utf-8
require 'test_helper.rb'
class BlockGeneratorTest < Minitest::Test

  require 'cocoa_bean/generator/block_generator'

  def setup
    @generator = CocoaBean::BlockGenerator.new do
      @flag = 'love'
    end
  end

  def teardown
    @generator = nil
    @flag = nil
  end

  def test_block_generator_is_not_abstract_by_default
    refute @generator.class.abstract?
  end

  def block_is_called_when_generate
    @generator.generate
    assert_equal 'love', @flag
  end

end
