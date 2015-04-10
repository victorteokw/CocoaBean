# coding: utf-8
require 'test_helper.rb'

class TemplateTest < Minitest::Test

  require 'fileutils'

  def setup
    @generator = CocoaBean::TemplateGenerator.new
    @generator.template = "coffee"
    @generator.destination = File.expand_path('cocoabean_test', Dir.tmpdir)
  end

  def teardown
    FileUtils::rm_rf(@generator.destination)
    @generator = nil
  end

  def test_template_generator_has_template
    assert_equal "coffee", @generator.template
  end

  def test_template_paths_should_exist
    assert File.exist?(@generator.template_paths[0])
  end

  def test_source_location_returns
    @generator.template = "coffee"
    assert @generator.source_location
  end

  def test_source_location_raises_if_not_found
    @generator.template = "youwontfindme"
    assert_raises CocoaBean::TemplateGenerator::TemplateSourceNotExistError do
      @generator.source_location
    end
  end

  def test_relative_path
    source = File.expand_path('love', @generator.source_location)
    rel = @generator.relative_path(source)
    assert_equal 'love', rel
  end

  def test_target_for_source
    source = File.expand_path('some_path/some_file', @generator.source_location)
    target = @generator.target_for_source(source)
    assert_equal File.expand_path('some_path/some_file', @generator.destination), target
  end

  def test_target_for_source_with_erb
    source = File.expand_path('some_path/some_file.erb', @generator.source_location)
    target = @generator.target_for_source(source, true)
    assert_equal File.expand_path('some_path/some_file', @generator.destination), target
  end

  def test_create_directory
    dir = File.expand_path('some', @generator.destination)
    silence_output do
      @generator.create_directory dir
    end
    assert Dir.exist? dir
  end

  def test_create_directory_raise_if_exist
    dir = File.expand_path('some', @generator.destination)
    silence_output do
      @generator.create_directory dir
    end
    assert_raises SystemExit do
      silence_output do
        @generator.create_directory dir
      end
    end
  end

  def test_process_file
    from = File.expand_path('abc.txt.erb', @generator.destination)
    to = File.expand_path('def.txt', @generator.destination)
    FileUtils::mkdir_p(File.dirname(from))
    File.open(from, 'w') {|f| f.write("love is everything") }

    silence_output do
      @generator.process_file(from, to)
    end
    assert File.exist?(to)
  end

  def test_process_file_raise_if_file_exist
    from = File.expand_path('abc.txt.erb', @generator.destination)
    to = File.expand_path('def.txt', @generator.destination)
    FileUtils::mkdir_p(File.dirname(from))
    File.open(from, 'w') {|f| f.write("love is everything") }
    File.open(to, 'w') {|f| f.write("love is everything") }
    assert_raises SystemExit do
      silence_output do
        @generator.process_file(from, to)
      end
    end
  end

  def test_copy_file
    from = File.expand_path('abc.txt', @generator.destination)
    to = File.expand_path('def.txt', @generator.destination)
    FileUtils::mkdir_p(File.dirname(from))
    File.open(from, 'w') {|f| f.write("love is everything") }

    silence_output do
      @generator.copy_file(from, to)
    end
    assert File.exist?(to)
  end

  def test_copy_file_raise_if_file_exist
    from = File.expand_path('abc.txt', @generator.destination)
    to = File.expand_path('def.txt', @generator.destination)
    FileUtils::mkdir_p(File.dirname(from))
    File.open(from, 'w') {|f| f.write("love is everything") }
    File.open(to, 'w') {|f| f.write("love is everything") }
    assert_raises SystemExit do
      silence_output do
        @generator.copy_file(from, to)
      end
    end
  end

  def test_generate
    skip "how to test this big method?"
  end
end
