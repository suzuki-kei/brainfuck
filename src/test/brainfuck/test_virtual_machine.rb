require 'stringio'
require 'test/unit'
require 'brainfuck/virtual_machine'
require_relative 'base'

module Brainfuck

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
            vm = VirtualMachine.new
            assert_equal [0] * 30000, vm.cells

            stdout = capture_stdout { vm.execute(HELLO_WORLD) }
            expected = [0, 111, 0, 100, 0, 33, 0, 10, *([0] * 30000)].take(30000)
            assert_equal expected, vm.cells
        end

        def test_used_cells
            vm = VirtualMachine.new
            assert_equal [0], vm.used_cells

            stdout = capture_stdout { vm.execute(HELLO_WORLD) }
            assert_equal [0, 111, 0, 100, 0, 33, 0, 10], vm.used_cells
        end

        def test_execute
            vm = VirtualMachine.new
            stdout = capture_stdout { vm.execute(HELLO_WORLD) }
            assert_equal "Hello, World!\r\n", stdout
            assert_equal [0, 111, 0, 100, 0, 33, 0, 10], vm.used_cells
        end

        def test_execute_input_command
            vm = VirtualMachine.new
            capture_stdin('') { vm.execute(',') }
            assert_equal [0], vm.used_cells

            vm = VirtualMachine.new
            capture_stdin('A') { vm.execute(',') }
            assert_equal ['A'.ord], vm.used_cells
        end

        def test_execute_raises_CommandError_when_cell_value_is_less_than_minimum_value
            vm = VirtualMachine.new
            assert_raises(CommandError) do
                vm.execute('+' * 128)
            end
        end

        def test_execute_raises_CommandError_when_cell_value_is_greater_than_maximum_value
            vm = VirtualMachine.new
            assert_raises(CommandError) do
                vm.execute('-' * 129)
            end
        end

        def test_execute_raises_CommandError_when_pointer_is_left_of_leftmost
            vm = VirtualMachine.new
            assert_raises(CommandError) do
                vm.execute('<')
            end
        end

        def test_execute_raises_CommandError_when_pointer_is_right_of_rightmost
            vm = VirtualMachine.new
            assert_raises(CommandError) do
                vm.execute('>' * 30000)
            end
        end

    end

end

