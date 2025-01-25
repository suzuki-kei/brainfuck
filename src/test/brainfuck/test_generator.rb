require_relative 'base'
require 'brainfuck/generator'
require 'brainfuck/virtual_machine'

module Brainfuck

    def self.new_test_case_class(generator_class)
        Class.new(TestCase) do
            define_method('test_generate') do
                text = "Hello, World!"
                code = generator_class.new.generate(text)
                stdout = capture_stdout { VirtualMachine.new.execute(code) }
                assert_equal text, stdout
            end
        end
    end

    [Generator1, Generator2].each do |generator_class|
        name = "#{generator_class.name.split('::').last}TestCase"
        const_set(name, new_test_case_class(generator_class))
    end

end

