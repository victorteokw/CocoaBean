# coding: utf-8
require 'test_helper.rb'

class ApplicationTest < Minitest::Test
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

  def test_app_has_name
    assert_equal @app.name, '제빵왕 김탁구'
  end

  def test_app_has_version
    assert_equal @app.version, '1.2'
  end

  def test_app_has_editor
    assert_equal @app.editor, 'emacs'
  end

  def test_code_location_by_default_is_app
    assert_equal @app.code_location, 'app'
  end

  def test_assets_location_by_default_is_assets
    assert_equal @app.assets_location, 'assets'
  end

  def test_distribution_directory_by_default_is_dist
    assert_equal @app.distribution_directory, 'dist'
  end

  def test_platform_has_some_default_value
    p = @app.get_platform(:web)
    assert_equal 'Web Browser', p.readable_name
    assert_equal true, p.supported
    assert_equal 'web', p.code_location
    assert_equal 'dist/web', p.distribution_directory
  end

  def test_to_s
    s = @app.to_s
    assert_match "#{@app.version}", s
    assert_match "#{@app.name}", s
    assert_match "#{@app.editor}", s
    assert_match "#{@app.code_location}", s
    assert_match "#{@app.assets_location}", s
    assert_match "#{@app.distribution_directory}", s
  end

  def test_verify_platform_name
    assert_raises CocoaBean::Application::PlatformNameError do
      @app = CocoaBean::Application.new do |app|
        app.name = "Name"
        app.version = '1.0'
        app.platform :not
      end
    end
  end

  def test_all_application
    all_apps = CocoaBean::Application.all
    assert_kind_of Array, all_apps, "CocoaBean::Application.all should return array"
    assert_includes all_apps, @app, "App should be in the instance list."
  end

  def test_only_app_returns_if_only_one
    GC.start
    assert_equal @app, CocoaBean::Application.only_app
  end

  def test_only_app_throws_if_not_only_one
    @second = CocoaBean::Application.new do |app|
      app.name = "옥탑방 왕세자"
    end
    assert_raises CocoaBean::Application::ApplicationCountError do
      CocoaBean::Application.only_app
    end
  end
end
