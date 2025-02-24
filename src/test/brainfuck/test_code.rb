require 'test/unit'
require 'brainfuck/code'
require 'brainfuck/virtual_machine'
require_relative 'base'

module Brainfuck

    class CodeTestCase < TestCase

        # [ms, c, n, size]
        [
            # ms.size == 0 の場合
            [[],  0,  0, 0],
            [[],  1,  1, 1],
            [[], -2, -2, 2],
            [[],  3,  3, 3],
            [[], -4, -4, 4],

            # ms.size == 1 の場合
            [[2],  0,  0, 0],
            [[2],  1,  1, 1],
            [[2], -2, -2, 2],
            [[2],  3,  3, 3],
            [[2], -4, -4, 4],

            # ms.size == 2 の場合
            [[2, 3],  0,  6, 0],
            [[2, 3],  1,  7, 1],
            [[2, 3], -2,  4, 2],
            [[2, 3],  3,  9, 3],
            [[2, 3], -4,  2, 4],

            # ms.size == 3 の場合
            [[2, 3, 4],  0, 24, 0],
            [[2, 3, 4],  1, 25, 1],
            [[2, 3, 4], -2, 22, 2],
            [[2, 3, 4],  3, 27, 3],
            [[2, 3, 4], -4, 20, 4],

            # ms に 0 が含まれる場合
            [[0, 3, 4],  0,  0, 0],
            [[2, 0, 4],  1,  1, 1],
            [[2, 3, 0], -2, -2, 2],
            [[2, 0, 4],  3,  3, 3],
            [[0, 3, 4], -4, -4, 4],
        ].each.with_index do |(ms, c, n, size), index|
            define_method("test_#{index + 1}") do
                code = Code.new(ms.clone, c.clone)
                assert_equal n, code.n
                assert_equal ms, code.ms
                assert_equal c, code.c
                assert_equal code.size, code.generate.size

                vm = VirtualMachine.new
                vm.execute(code.generate)
                assert_equal n, vm.cells[0]
            end
        end

    end

end

