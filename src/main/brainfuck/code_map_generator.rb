require_relative 'code_map'
require_relative 'specification'

module Brainfuck

    class CodeMapGenerator

        include Specification

        def generate
            CodeMap.generate(MIN_CELL_VALUE..MAX_CELL_VALUE).sort.map do |n, code|
                sprintf("%d\t%s", n, code.generate)
            end.join("\n")
        end

    end

end

