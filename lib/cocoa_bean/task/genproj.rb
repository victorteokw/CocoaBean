require 'pathname'
require 'fileutils'
require 'erb'


def relative_path(full_path, prefix = nil)
  prefix ||= source_location
  Pathname.new(full_path).relative_path_from(Pathname.new(prefix)).to_s
end

def output_create_file(file_or_dir)
  rel = Pathname.new(file_or_dir).relative_path_from(Pathname.new(File.dirname(destination))).to_s
  color = "created".green.bold
  puts "    #{color} #{rel}"
end

class BindingObject

  def initialize(path)
    last_path_component = File.basename(path)

    @author_name = ENV['USER']
    @created_at = Time.now.strftime("%d/%m/%Y %H:%M")
    @created_year = Time.now.strftime("%Y")
    @module_name = last_path_component.upcase
    @app_name = last_path_component.downcase
    @app_readable_name = last_path_component.capitalize
  end

  def get_binding
    binding
  end

end

BO = BindingObject

namespace "gen" do
  namespace "proj" do
    namespace "base" do
      task "all", :lang, :dest do |t, args|
        lang = args[:lang]
        dest = args[:dest]

        # TODO: should test dest not exist, if exist, exit with status code 1

        template_directory = File.expand_path('../../../../templates/base', __FILE__)
        template_dir_for_lang = File.expand_path(lang, template_directory)

        sources = Dir.glob File.expand_path('**/*', template_dir_for_lang)
        sources.reject! {|f| [".", "..", ".DS_Store"].include? File.basename(f) }
        sources.each do |f|
          target = f.gsub(template_dir_for_lang, dest).gsub('.erb', '')

          if File.directory? f
            directory target do |t|
              UI.happy "#{target} directory created"
            end.invoke
          elsif File.extname(f) == '.erb'
            file target => f do |t|
              renderer = ERB.new(File.read(f))
              File.write(target, renderer.result(BindingObject.new(dest).get_binding))
              UI.happy "#{target} processed"
            end.invoke
          else
            file target => f do |t|
              FileUtils::cp(f, target)
              UI.happy "#{target} created"
            end.invoke
          end
        end

      end
    end

    namespace "web" do
      task "all", :dest, :app_dir do |t, args|
        dest = args[:dest]
        app_dir = args[:app_dir]

        directory dest do |t|
          UI.happy "#{dest} directory created"
        end.invoke

        template_directory = File.expand_path('../../../../templates/web', __FILE__)
        sources = Dir.glob File.expand_path('**/*', template_directory)
        sources.reject! {|f| [".", "..", ".DS_Store"].include? File.basename(f) }
        sources.each do |f|
          target = f.gsub(template_directory, dest).gsub('.erb', '')

          if File.directory? f
            directory target do |t|
              UI.happy "#{target} directory created"
            end.invoke
          elsif File.extname(f) == '.erb'
            file target => f do |t|
              renderer = ERB.new(File.read(f))
              File.write(target, renderer.result(BindingObject.new(app_dir).get_binding))
              UI.happy "#{target} processed"
            end.invoke
          else
            file target => f do |t|
              FileUtils::cp(f, target)
              UI.happy "#{target} created"
            end.invoke
          end
        end

      end
    end

    namespace "assets" do
      task "all", :dest_app_dir do |t, args|
        dest = args[:dest_app_dir]
        dest_ass_dir = File.expand_path('assets', dest)

        directory dest_ass_dir do |t|
          UI.happy "#{dest_ass_dir} directory created"
        end.invoke

        assets_from = File.expand_path('../../../../templates/assets', __FILE__)

        sources = Dir.glob File.expand_path('*', assets_from)
        sources.reject! {|f| [".", "..", ".DS_Store"].include? File.basename(f) }
        sources.each do |f|
          target = f.gsub(assets_from, dest_ass_dir).gsub('.erb', '')
          file target => f do
            FileUtils::cp(f, target)
            UI.happy "#{target} created"
          end.invoke
        end
      end
    end

    namespace "ios" do
    end

    namespace "osx" do
    end

    namespace "and" do
    end

    namespace "win" do
    end
  end
end
