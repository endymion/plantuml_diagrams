# frozen_string_literal: true

require_relative "lib/plantuml_diagrams/version"

Gem::Specification.new do |spec|
  spec.name = "plantuml_diagrams"
  spec.version = PlantumlDiagrams::VERSION
  spec.authors = ["Ryan Alyn Porter"]
  spec.email = ["rap@endymion.com"]

  spec.summary = "Generate SVG and PNG files for PlantUML diagrams."
  spec.description = "Manages the generation of SVG and PNG files for PlantUML diagrams, and optionally watches for changes to the source files and regenerates the images."
  spec.homepage = "http://example.com"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "http://example.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end

  spec.bindir        = "exe"
  spec.executables   = ["plantuml_diagrams"]

  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.0"
  spec.add_dependency "filewatcher", "~> 1.0"
  spec.add_dependency "pil", "~> 0.1"
  spec.add_dependency "fileutils", "~> 1.5"
end
