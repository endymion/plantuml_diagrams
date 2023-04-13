# generate_diagrams.rb

require 'thor'
require 'filewatcher'
require 'pil'
require 'fileutils'

module PlantumlDiagrams
  class GenerateDiagrams < Thor
    desc "process", "Process PlantUML files and display generated images."
    method_option :jar, aliases: "-j", default: File.join(File.dirname(__FILE__), "plantuml.jar"), desc: "Path to the PlantUML jar file."
    method_option :input, aliases: "-i", default: File.dirname(__FILE__), desc: "Path to the folder containing PlantUML files."
    method_option :output, aliases: "-o", default: File.join(File.dirname(__FILE__), "images"), desc: "Path to the folder where generated images will be saved."
    method_option :name, aliases: "-n", desc: "Process only diagrams with file names matching this argument."
    method_option :display, aliases: "-d", type: :boolean, desc: "Display generated images."
    method_option :watch, aliases: "-w", type: :boolean, desc: "Continuously watch for changes to the file(s)."
    def process
      FileUtils.mkdir_p(options[:output])

      plantuml_files = Dir.glob(File.join(options[:input], "*.puml"))

      if options[:name]
        plantuml_files.select! { |f| File.basename(f).include?(options[:name]) }
      end

      puts "Watching the following files:"
      plantuml_files.each { |f| puts "  - #{f}" }

      file_types = ["PNG", "SVG"]

      if options[:watch]
        filewatcher = Filewatcher.new(plantuml_files)
        filewatcher.watch do |changes|
          changes.each do |filename, event|
            puts "Detected event: #{event} for file: #{filename}"
            if event == :updated
              puts "Processing #{filename}"
              run_plantuml(options[:jar], filename, options[:output], file_types, options[:display])
            end
          end
        end
      else
        plantuml_files.each do |plantuml_file|
          puts "Processing #{plantuml_file}"
          run_plantuml(options[:jar], plantuml_file, options[:output], file_types, options[:display])
        end
      end
    end

    private

    def run_plantuml(plantuml_jar_path, input_file, output_folder, file_types, display)
      file_name = File.basename(input_file, '.puml')

      file_types.each do |file_type|
        output_file = File.join(output_folder, "#{file_name}.#{file_type.downcase}")
        plantuml_command = %{java -jar "#{plantuml_jar_path}" -t#{file_type} -o "#{output_folder}" "#{input_file}"}
        system(plantuml_command)

        display_image(output_file) if display && file_type == "PNG"
      end
    end

    def display_image(image_path)
      Pil::Image.open(image_path).show
    end
  end
end