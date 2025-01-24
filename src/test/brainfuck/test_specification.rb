require_relative 'base'
require 'brainfuck/specification'

module Brainfuck

    class SpecificationTestCase < TestCase

        def test_COMMANDS
            assert_equal %w(+ - > < [ ] . ,).sort, Specification::COMMANDS.sort
        end

        def test_NUMBER_OF_CELLS
            assert_equal 30000, Specification::NUMBER_OF_CELLS
        end

        def test_MIN_CELL_VALUE
            assert_equal -128, Specification::MIN_CELL_VALUE
        end

        def test_MAX_CELL_VALUE
            assert_equal 127, Specification::MAX_CELL_VALUE
        end

    end

end

