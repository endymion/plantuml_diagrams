# generate_diagrams.rb

require 'thor'
require 'filewatcher'
require 'pil'
require 'fileutils'
require 'net/http'
require 'uri'

module PlantumlDiagrams
  class GenerateDiagrams < Thor
    desc "process", "Process PlantUML files and display generated images."
    method_option :jar, aliases: "-j", default: File.join(Dir.pwd, "plantuml.jar"), desc: "Path to the PlantUML jar file."
    method_option :input, aliases: "-i", default: Dir.pwd, desc: "Path to the folder containing PlantUML files."
    method_option :output, aliases: "-o", default: File.join(Dir.pwd, "images"), desc: "Path to the folder where generated images will be saved."
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

    desc "download_jar", "Download the PlantUML jar file."
    def download_jar
      plantuml_jar_url = 'https://github.com/plantuml/plantuml/releases/download/v1.2023.5/plantuml.jar'
      output_path = File.join(Dir.pwd, "plantuml.jar")

      puts "Downloading PlantUML jar file from #{plantuml_jar_url}..."
      download_file(plantuml_jar_url, output_path)
      puts "PlantUML jar file has been downloaded to #{output_path}"
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

    def download_file(url, output_path)
      uri = URI(url)

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Get.new(uri)

        http.request(request) do |response|
          if response.is_a?(Net::HTTPRedirection) && response['location']
            download_file(response['location'], output_path)
          elsif response.is_a?(Net::HTTPSuccess)
            File.open(output_path, 'wb') do |file|
              response.read_body do |chunk|
                file.write(chunk)
              end
            end
          else
            raise "Error: Failed to download the file"
          end
        end
      end
    end
  end
end
