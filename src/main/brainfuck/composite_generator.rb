module Brainfuck

    # 複数の Generator でコードを生成し, 最も短いものを結果とする Generator.
    class CompositeGenerator

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

