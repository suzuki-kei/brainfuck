require_relative 'base'
require 'brainfuck/build_string_generator'

module Brainfuck

    class BuildStringGeneratorTestCase < TestCase

        def test_generate
            generator = BuildStringGenerator.new

            assert_equal <<~'EOS'.strip, generator.generate('hello')
                >++++++++[-<+++++++++++++>]
                >++++++++++[-<++++++++++>]<+>
                >+++++++++[-<++++++++++++>]
                >+++++++++[-<++++++++++++>]
                >++++++++++[-<+++++++++++>]<+>
            EOS
        end

    end

end

