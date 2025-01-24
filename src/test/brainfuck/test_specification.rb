require_relative 'base'
require 'brainfuck/specification'

module Brainfuck

    class SpecificationTestCase < TestCase

        class SpecificationIncluded
            include Brainfuck::Specification
        end

        def test_COMMANDS
            assert_equal 8, SpecificationIncluded::COMMANDS.size
            assert_true SpecificationIncluded::COMMANDS.include?('+')
            assert_true SpecificationIncluded::COMMANDS.include?('-')
            assert_true SpecificationIncluded::COMMANDS.include?('>')
            assert_true SpecificationIncluded::COMMANDS.include?('<')
            assert_true SpecificationIncluded::COMMANDS.include?('[')
            assert_true SpecificationIncluded::COMMANDS.include?(']')
            assert_true SpecificationIncluded::COMMANDS.include?('.')
            assert_true SpecificationIncluded::COMMANDS.include?(',')
        end

        def test_NUMBER_OF_CELLS
            assert_equal 30000, SpecificationIncluded::NUMBER_OF_CELLS
        end

        def test_MIN_CELL_VALUE
            assert_equal -128, SpecificationIncluded::MIN_CELL_VALUE
        end

        def test_MAX_CELL_VALUE
            assert_equal 127, SpecificationIncluded::MAX_CELL_VALUE
        end

    end

end

