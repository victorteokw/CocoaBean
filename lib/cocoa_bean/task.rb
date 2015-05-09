require 'rake'

UI = CocoaBean::UserInterface

def invoke(name, *args)
  Rake::Task[name].invoke(*args)
end

module CocoaBean
  class Task
    require 'cocoa_bean/task/dist'
    require 'cocoa_bean/task/genapp'
    require 'cocoa_bean/task/preview'
    require 'cocoa_bean/task/test'

    def self.invoke(task_name, *args)
      Rake::Task[task_name].invoke(*args)
    end

    def self.root_directory_of_cocoa_bean
      File.expand_path('../../../', __FILE__)
    end

  end
end
