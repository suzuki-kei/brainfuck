require 'optparse'
require_relative 'errors'
require_relative 'generator1'
require_relative 'generator2'
require_relative 'generator3'
require_relative 'generator4'
require_relative 'parser'
require_relative 'virtual_machine'

module Brainfuck

    class Application

        def run
            case ARGV.first
                when 'generate'
                    ARGV.shift
                    run_as_generator
                when 'minify'
                    ARGV.shift
                    run_as_minifier
                else
                    run_as_interpreter
            end
        rescue BrainfuckError => error
            $stderr.puts "#{error.class.name.split('::').last} - #{error.to_s}"
        rescue Interrupt
            # ignore
        end

        private

        def run_as_interpreter
            source_code = ARGF.read
            vm = VirtualMachine.new
            vm.execute(source_code)
        end

        def run_as_generator
            case option = ARGV.shift
                when '-1', '--generator1'
                    generate_code(Generator1.new)
                when '-2', '--generator2'
                    generate_code(Generator2.new)
                when '-3', '--generator3'
                    generate_code(Generator3.new)
                when '-4', '--generator4'
                    generate_code(Generator4.new)
                when '-s', '--shortest-codes'
                    print_shortest_codes
                else
                    ARGV.unshift(option)
            end
        end

        def generate_code(generator)
            text = ARGF.read
            code = generator.generate(text)
            puts Parser.new.parse(code).size
            puts code
        end

        def print_shortest_codes
            map = Brainfuck::CharacterToCodeMap.new
            map.dump
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

