# coding: utf-8
require 'test_helper.rb'

class ApplicationTest < Minitest::Test
  def setup
    @app = CocoaBean::Application.new do |app|
      app.name = '제빵왕 김탁구'
      app.version = '1.2'
      app.supported_platform = ['ios', 'osx', 'web']
      app.editor = 'emacs'
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

  def test_app_has_supported_platform
    assert_equal @app.supported_platform, ['ios', 'osx', 'web']
  end

  def test_app_has_editor
    assert_equal @app.editor, 'emacs'
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
      app.name = '옥탑방 왕세자'
    end
    assert_raises CocoaBean::Application::ApplicationCountError do
      CocoaBean::Application.only_app
    end
  end
end
