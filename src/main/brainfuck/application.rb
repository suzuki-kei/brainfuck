require 'optparse'
require_relative 'code_map'
require_relative 'composite_generator'
require_relative 'errors'
require_relative 'generator1'
require_relative 'generator2'
require_relative 'generator3'
require_relative 'generator4'
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
                when :generator
                    run_as_generator
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
                    when 'generate'
                        ARGV.shift
                        options[:mode] = :generator
                    when 'minify'
                        ARGV.shift
                        options[:mode] = :minifier
                    else
                        options[:mode] = :interpreter
                end

                parser.on('-h', '--help') {
                    options[:mode] = :help
                }

                if options[:mode] == :generator
                    options.merge!({
                        generator: :composite_generator,
                    })
                    parser.on('-0') {
                        options[:generator] = :composite_generator
                    }
                    parser.on('-1', '--generator1') {
                        options[:generator] = :generator1
                    }
                    parser.on('-2', '--generator2') {
                        options[:generator] = :generator2
                    }
                    parser.on('-3', '--generator3') {
                        options[:generator] = :generator3
                    }
                    parser.on('-4', '--generator4') {
                        options[:generator] = :generator4
                    }
                    parser.on('-s', '--shortest-codes') {
                        options[:generator] = :shortest_codes
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

        def run_as_generator
            case @options[:generator]
                when :composite_generator
                    generate_code(new_composite_generator)
                when :generator1
                    generate_code(Generator1.new)
                when :generator2
                    generate_code(Generator2.new)
                when :generator3
                    generate_code(Generator3.new)
                when :generator4
                    generate_code(Generator4.new)
                when :shortest_codes
                    print_shortest_codes
                else
                    raise 'Bug'
            end
        end

        def new_composite_generator
            CompositeGenerator.new([
                Generator1.new,
                Generator2.new,
                Generator3.new,
                Generator4.new,
            ])
        end

        def generate_code(generator)
            text = ARGF.read
            code = generator.generate(text)
            puts Parser.new.parse(code).size
            puts code
        end

        def print_shortest_codes
            CodeMap.generate(MIN_CELL_VALUE..MAX_CELL_VALUE).sort.each do |n, code|
                puts sprintf("%d\t%s", n, code.generate)
            end
        end

        def run_as_minifier
            code = ARGF.read
            minified_code = Parser.new.parse(code)
            print minified_code
        end

    end

end

if $0 == __FILE__
    Brainfuck::Application.new.run
end

