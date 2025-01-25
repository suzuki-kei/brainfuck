require_relative 'base'
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

    (1..2).each do |i|
        name = "generator#{i}"
        require "brainfuck/#{name}"
        generator_class_name = name.capitalize
        generator_class = const_get(generator_class_name)

        test_case_class_name = "#{generator_class_name}TestCase"
        test_case_class = new_test_case_class(generator_class)
        const_set(test_case_class_name, test_case_class)
    end

end

