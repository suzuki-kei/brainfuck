require 'optparse'
require_relative 'build_string_generator'
require_relative 'code_map'
require_relative 'composite_output_string_generator'
require_relative 'errors'
require_relative 'minifier'
require_relative 'output_string_generator1'
require_relative 'output_string_generator2'
require_relative 'output_string_generator3'
require_relative 'output_string_generator4'
require_relative 'parser'
require_relative 'specification'
require_relative 'virtual_machine'

module Brainfuck

    class Application

        include Specification

        def run
            @options = parse_options

            case @options[:mode]
                when :help
                    print_help
                when :interpreter
                    run_as_interpreter
                when :build_string_generator
                    run_as_build_string_generator
                when :output_string_generator
                    run_as_output_string_generator
                when :code_map_generator
                    run_as_code_map_generator
                when :minifier
                    run_as_minifier
                else
                    print_help
            end
        rescue BrainfuckError => error
            $stderr.puts "#{error.class.name.split('::').last} - #{error.to_s}"
        rescue OptionParser::InvalidOption => error
            $stderr.puts error.to_s
        rescue Interrupt
            # ignore
        end

        private

        def parse_options
            {}.tap do |options|
                parser = OptionParser.new

                case ARGV.first
                    when 'build-string-generator'
                        ARGV.shift
                        options[:mode] = :build_string_generator
                    when 'output-string-generator'
                        ARGV.shift
                        options[:mode] = :output_string_generator
                    when 'code-map-generator'
                        ARGV.shift
                        options[:mode] = :code_map_generator
                    when 'minify'
                        ARGV.shift
                        options[:mode] = :minifier
                    else
                        options[:mode] = :interpreter
                end

                parser.on('-h', '--help') {
                    options[:mode] = :help
                }

                if options[:mode] == :output_string_generator
                    options.merge!({
                        generator: :composite_output_string_generator,
                    })
                    parser.on('-a', '--algorithm-all') {
                        options[:generator] = :composite_output_string_generator
                    }
                    parser.on('-1', '--algorithm-1') {
                        options[:generator] = :output_string_generator1
                    }
                    parser.on('-2', '--algorithm-2') {
                        options[:generator] = :output_string_generator2
                    }
                    parser.on('-3', '--algorithm-3') {
                        options[:generator] = :output_string_generator3
                    }
                    parser.on('-4', '--algorithm-4') {
                        options[:generator] = :output_string_generator4
                    }
                end

                parser.parse!(ARGV)
            end
        end

        def print_help
            usage_file_path = File.join(File.dirname($0), 'usage.txt')
            puts File.read(usage_file_path)
        end

        def run_as_interpreter
            source_code = ARGF.read
            vm = VirtualMachine.new
            vm.execute(source_code)
        end

        def run_as_build_string_generator
            generate_build_string_code
        end

        def run_as_output_string_generator
            case @options[:generator]
                when :composite_output_string_generator
                    generate_output_string_code(CompositeOutputStringGenerator.new([
                            OutputStringGenerator1.new,
                            OutputStringGenerator2.new,
                            OutputStringGenerator3.new,
                            OutputStringGenerator4.new,
                    ]))
                when :output_string_generator1
                    generate_output_string_code(OutputStringGenerator1.new)
                when :output_string_generator2
                    generate_output_string_code(OutputStringGenerator2.new)
                when :output_string_generator3
                    generate_output_string_code(OutputStringGenerator3.new)
                when :output_string_generator4
                    generate_output_string_code(OutputStringGenerator4.new)
                else
                    raise BrainfuckError, 'Bug'
            end
        end

        def generate_build_string_code
            text = ARGF.read
            generator = BuildStringGenerator.new
            puts generator.generate(text)
        end

        def generate_output_string_code(generator)
            text = ARGF.read
            code = generator.generate(text)
            puts Parser.new.parse(code).size
            puts code
        end

        def run_as_code_map_generator
            CodeMap.generate(MIN_CELL_VALUE..MAX_CELL_VALUE).sort.each do |n, code|
                puts sprintf("%d\t%s", n, code.generate)
            end
        end

        def run_as_minifier
            code = ARGF.read
            puts Minifier.new.minify(code)
        end

    end

end

if $0 == __FILE__
    Brainfuck::Application.new.run
end

