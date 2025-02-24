require_relative 'parser'

module Brainfuck

    # 複数の OutputStringGenerator でコードを生成し, 最も短いものを結果とする OutputStringGenerator.
    class CompositeOutputStringGenerator

        def initialize(generators)
            @generators = generators
        end

        def generate(text)
            codes = @generators.map do |generator|
                generator.generate(text)
            end
            sorted_codes = codes.sort_by do |code|
                Parser.new.parse(code).size
            end
            sorted_codes.first
        end

    end

end

