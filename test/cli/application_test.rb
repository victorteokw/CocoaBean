# coding: utf-8
require 'test_helper.rb'

class ApplicationTest < CocoaBean::Test
  def setup
    @app = CocoaBean::Application.new do |app|
      app.name = '제빵왕 김탁구'
      app.version = '1.2'
      app.editor = 'emacs'
      app.platform :web
    end
    @second = nil
  end

  def teardown
    @app = nil
    @second = nil
  end

  test "app has name" do
    assert_equal @app.name, '제빵왕 김탁구'
  end

  test "app has version" do
    assert_equal @app.version, '1.2'
  end

  test "app has editor" do
    assert_equal @app.editor, 'emacs'
  end

  test "code location by default is app" do
    assert_equal @app.code_location, 'app'
  end

  test "assets location by default is assets" do
    assert_equal @app.assets_location, 'assets'
  end

  test "distribution directory by default is dist" do
    assert_equal @app.distribution_directory, 'dist'
  end

  test "platform has some default value" do
    p = @app.get_platform(:web)
    assert_equal 'Web Browser', p.readable_name
    assert_equal true, p.supported
    assert_equal 'web', p.code_location
    assert_equal 'dist/web', p.distribution_directory
  end

  test "to s" do
    s = @app.to_s
    assert_match "#{@app.version}", s
    assert_match "#{@app.name}", s
    assert_match "#{@app.editor}", s
    assert_match "#{@app.code_location}", s
    assert_match "#{@app.assets_location}", s
    assert_match "#{@app.distribution_directory}", s
  end

  test "verify platform name" do
    assert_raises CocoaBean::Application::PlatformNameError do
      @app = CocoaBean::Application.new do |app|
        app.name = "Name"
        app.version = '1.0'
        app.platform :not
      end
    end
  end

  test "all application" do
    all_apps = CocoaBean::Application.all
    assert_kind_of Array, all_apps, "CocoaBean::Application.all should return array"
    assert_includes all_apps, @app, "App should be in the instance list."
  end

  test "only app returns if only one" do
    GC.start
    assert_equal @app, CocoaBean::Application.only_app
  end

  test "only app throws if not only one" do
    @second = CocoaBean::Application.new do |app|
      app.name = "옥탑방 왕세자"
    end
    assert_raises CocoaBean::Application::ApplicationCountError do
      CocoaBean::Application.only_app
    end
  end
end
