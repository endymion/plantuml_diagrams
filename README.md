# Plantuml Diagrams

Plantuml Diagrams is a Ruby gem that processes [PlantUML](https://plantuml.com/) files and generates images based on the diagrams. It includes a command-line interface (CLI) using Thor to specify the location of the input files, the output location for the generated images, and other parameters.

## Motivation

We're using Markdown files directly within Git repositories for all the ITSM documentation related to our workloads.  Not just code documentation, but also design documentation, playbooks, runbooks.  We need to incorporate a lot of diagrams into our documentation.  GitHub supports embedding Mermaid.js diagrams directly into GitHub-flavored Markdown, but PlantUML is a lot more powerful.  I started by manually generating PNG files using a PlantUML live editor.  Then I progressed to Jupyter notebook that ran a local PlantUML .jar to generate PNG files for me in VS Code.  Then I made that into a simple Python script and got rid of Jupyter.  Our projects mostly use Ruby code on the backend, so then I ported it to Ruby.  And I want to use the same code in lots of projects, so I made it into a reusable gem.

The `--watch` feature is handy during development.  Your live preview in VS Code will update automatically whenever you change any Markdown file or your PlantUML diagrams.  That's powerful stuff, for a documentation author.

## Installation

Install the gem using Bundler:

    $ bundle add plantuml_diagrams

If you are not using Bundler, you can install the gem by running:

    $ gem install plantuml_diagrams

### Prerequisites

#### Java

To render the diagrams, you'll need to install Java.

#### PlantUML

And then you'll also need PlantUML. Grab the `.jar` file from https://plantuml.com/download

This code assumes that the file is available as `plantuml.jar` in your project's `diagrams/` folder, where your PlantUML code files are located.  You'll run the generator command from that current working folder.  You can explicitly specify the path of the `.jar` file with a command-line argument if necessary.

You can make a `plantuml.jar` available by making a symbolic link from the file you downloaded with the specific version in the filename to the more generic name:

    ln -s plantuml-1.2023.5.jar plantuml.jar

### Graphviz

Some diagrams also require Graphviz.

## Usage

To generate diagrams from PlantUML files, run the following command:

    $ plantuml_diagrams process [OPTIONS]

By default, this command will look for PlantUML files in the lib directory of the gem and save the generated images in the images directory of the gem. The generated images will be in PNG and SVG format.

### Options

The following options can be used to customize the behavior of the process command:

* `-j`, `--jar`: Path to the PlantUML jar file. Default is the plantuml.jar file located in the lib directory of the gem.
* `-i`, `--input`: Path to the folder containing PlantUML files. Default is the lib directory of the gem.
* `-o`, `--output`: Path to the folder where generated images will be saved. Default is the images directory of the gem.
* `-n`, `--name`: Process only diagrams with file names matching this argument.
* `-d`, `--display`: Display generated images.
* `-w`, `--watch`: Continuously watch for changes to the file(s).

### Examples

To generate diagrams from all the PlantUML files in the current directory and its subdirectories, run:

    $ plantuml_diagrams process

To generate diagrams only for files whose names include the string "class", run:

    $ plantuml_diagrams process -n class

To continuously watch for changes in the input files and regenerate the images, run:

    $ plantuml_diagrams process -w


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test-unit` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/plantuml_diagrams.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
