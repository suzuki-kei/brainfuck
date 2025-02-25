require 'brainfuck/code_map_generator'
require 'brainfuck/specification'
require 'brainfuck/virtual_machine'
require_relative 'base'

module Brainfuck

    class CodeMapGeneratorTestCase < TestCase

        include Specification

        def test_generate
            generator = CodeMapGenerator.new

            generator.generate.lines.each do |line|
                split = line.split(/\s+/)
                n, code = split[0].to_i, split[1].to_s
                vm = VirtualMachine.new
                vm.execute(code)
                assert_equal n, vm.cells[0]
            end
        end

    end

end

