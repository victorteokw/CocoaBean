module CocoaBean
  class Task
    def self.invoke(task_name, *args)
      require 'rake'
      require File.expand_path('helpers/build_js.rb', self.root_directory_of_tasks)
      load_rake_file_for_task_named(task_name)
      Rake::Task[task_name].invoke(*args)
    end

    def self.load_rake_file_for_task_named(task_name)
      tokens = task_name.split(":")
      tokens.pop
      path = tokens.join('/') + '.rake'
      load File.expand_path(path, root_directory_of_tasks)
    end

    def self.root_directory_of_cocoa_bean
      File.expand_path('../../../', __FILE__)
    end

    def self.root_directory_of_tasks
      File.expand_path('tasks', root_directory_of_cocoa_bean)
    end
  end
end
