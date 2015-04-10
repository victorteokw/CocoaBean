# coding: utf-8
require 'test_helper.rb'

class GeneratorTest < Minitest::Test

  def setup
    @generator = CocoaBean::Generator.new
    @generator.class.abstract!
  end

  def teardown
    @generator = nil
  end

  def test_abstract_generator_cannot_generate
    assert_raises CocoaBean::Generator::AbstractGeneratorCannotGenerateError do
      @generator.generate
    end
  end

  def test_generator_is_abstract
    assert_equal @generator.class.abstract, true
  end

  def test_generator_can_be_not_abstract
    @generator.class.abstract = false
    assert_equal @generator.class.abstract?, false
  end

  def test_generator_can_be_abstract
    @generator.class.abstract = false
    @generator.class.abstract!
    assert_equal @generator.class.abstract?, true
  end

  def test_has_destination
    @generator.destination = "2"
    assert_equal "2", @generator.destination
  end
end
