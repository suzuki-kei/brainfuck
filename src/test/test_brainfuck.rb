require 'stringio'
require 'test/unit'
require 'brainfuck'

module Brainfuck

    class TestCase < Test::Unit::TestCase

        protected

        def capture_stdout
            original_stdout = $stdout
            $stdout = StringIO.new
            yield
            $stdout.string
        ensure
            $stdout = original_stdout
        end

    end

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

    class ParserTestCase < TestCase

        def test_parse
            source_code = <<~'EOS'
                # H
                ++++++++[->+++++++++<]>.
                # e
                <++++[->+++++++<]>+.
                # l
                +++++++.
                # l
                .
                # o
                +++.
            EOS
            expected = '++++++++[->+++++++++<]>.<++++[->+++++++<]>+.+++++++..+++.'
            actual = Brainfuck::Parser.new.parse(source_code)
            assert_equal expected, actual
        end

        [
            'あ',
            '>あ',
            'あ<',
            'テスト',
            '>テ+ス+ト<',
        ].each.with_index do |source_code, index|
            define_method("test_parse_raises_ParseError_when_source_code_includes_non_ascii_character_#{index + 1}") do
                assert_raises(Brainfuck::ParseError) do
                    Brainfuck::Parser.new.parse(source_code)
                end
            end
        end

        [
            '[',
            ']',
        ].each.with_index do |source_code, index|
            define_method("test_parse_raises_SyntaxError_when_unmatched_brackets_exists_#{index + 1}") do
                assert_raises(Brainfuck::SyntaxError) do
                    Brainfuck::Parser.new.parse(source_code)
                end
            end
        end

    end

    class VirtualMachineTestCase < TestCase

        HELLO_WORLD = <<~'EOS'
            ++++++++[->+++++++++<]>.
            <++++[->+++++++<]>+.
            +++++++.
            .
            +++.
            >++++[->+++++++++++<]>.
            ------------.
            <+++++[->+++++++++++<]>.
            <++++[->++++++<]>.
            +++.
            ------.
            --------.
            >++++[->++++++++<]>+.
            >+++[->++++<]>+.
            ---.
        EOS

        def test_cells
            vm = Brainfuck::VirtualMachine.new
            assert_equal [0] * 30000, vm.cells

            stdout = capture_stdout { vm.execute(HELLO_WORLD) }
            expected = [0, 111, 0, 100, 0, 33, 0, 10, *([0] * 30000)].take(30000)
            assert_equal expected, vm.cells
        end

        def test_used_cells
            vm = Brainfuck::VirtualMachine.new
            assert_equal [0], vm.used_cells

            stdout = capture_stdout { vm.execute(HELLO_WORLD) }
            assert_equal [0, 111, 0, 100, 0, 33, 0, 10], vm.used_cells
        end

        def test_execute
            vm = Brainfuck::VirtualMachine.new
            stdout = capture_stdout { vm.execute(HELLO_WORLD) }
            assert_equal "Hello, World!\r\n", stdout
            assert_equal [0, 111, 0, 100, 0, 33, 0, 10], vm.used_cells
        end

        def test_execute_raises_CommandError_when_cell_value_is_less_than_minimum_value
            vm = Brainfuck::VirtualMachine.new
            assert_raises(Brainfuck::CommandError) do
                vm.execute('+' * 128)
            end
        end

        def test_execute_raises_CommandError_when_cell_value_is_greater_than_maximum_value
            vm = Brainfuck::VirtualMachine.new
            assert_raises(Brainfuck::CommandError) do
                vm.execute('-' * 129)
            end
        end

        def test_execute_raises_CommandError_when_pointer_is_left_of_leftmost
            vm = Brainfuck::VirtualMachine.new
            assert_raises(Brainfuck::CommandError) do
                vm.execute('<')
            end
        end

        def test_execute_raises_CommandError_when_pointer_is_right_of_rightmost
            vm = Brainfuck::VirtualMachine.new
            assert_raises(Brainfuck::CommandError) do
                vm.execute('>' * 30000)
            end
        end

    end

end

