require 'test/unit'
require 'brainfuck/code_map'
require_relative 'base'

module Brainfuck

    class CodeMapTestCase < TestCase

        def test_initialize
            map = CodeMap.generate(-127..128)
            assert_equal (-127..128).to_a, map.keys.sort

            map.each do |n, code|
                assert_equal n, code.n
                assert_equal code.size, code.generate.size
            end
        end

    end

end

