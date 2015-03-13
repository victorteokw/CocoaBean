module CocoaBean
  class Generator
    def initialize(options)
      @coffee = options[:coffee]
      @path = options[:path]
      @web = options[:web]
      @cocoa = options[:cocoa]
    end

    def generate
      # README.md
      # LICENSE
      # Beanfile
      # src/application.js.coffee
      # src/main.js.coffee
      # src/model_name/model_name.js.coffee
      # src/view/view.js.coffee
      # src/view_controller/view_controller.js.coffee
      # web/index.html.slim
      # cocoa/model_name.xcodeproj
      # cocoa/model_name/AppDelegate.{h,m}
      # spec/model_name_spec.js
      # spec/view/view_spec.js.coffee
      # spec/view_controller/view_spec.js.coffee
    end

  end
end
