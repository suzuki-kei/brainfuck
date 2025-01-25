require_relative 'base'
require 'brainfuck/generator'
require 'brainfuck/virtual_machine'

module Brainfuck

    class Generator1TestCase < TestCase

        def test_generate
            text = "Hello, World!"
            code = Generator1.new.generate(text)
            stdout = capture_stdout { VirtualMachine.new.execute(code) }
            assert_equal text, stdout
        end

    end

end

