require_relative 'specification'

module Brainfuck

    class CharacterToCodeMap

        def initialize
            @map = generate_map
        end

        def [](n)
            @map[n]
        end

        private

        include Specification

        def generate_map
            {}.tap do |map|
                (1 .. MAX_CELL_VALUE).each do |a|
                    min_b = (MIN_CELL_VALUE / a.to_f).ceil
                    max_b = (MAX_CELL_VALUE / a.to_f).floor

                    (min_b .. max_b).each do |b|
                        code = Code.new(a, b, 0)
                        shortest_code = map.fetch(code.n, code)
                        map[code.n] = code if code.code_length <= shortest_code.code_length

                        min_c = MIN_CELL_VALUE - (a * b)
                        max_c = MAX_CELL_VALUE - (a * b)

                        (min_c .. max_c).each do |c|
                            code = Code.new(a, b, c)
                            shortest_code = map.fetch(code.n, code)
                            map[code.n] = code if code.code_length <= shortest_code.code_length
                        end
                    end
                end
            end
        end

        class Code

            attr_reader :a, :b, :c, :n, :code_length

            def initialize(a, b, c)
                @a = a
                @b = b
                @c = c
                @n = calculate_n(a, b, c)
                @code_length = calculate_code_length(a, b, c)
            end

            def generate
                code1 = case
                    when @a == 0 || @b == 0
                        ''
                    when @n < 0
                        "#{'+' * @a}[->#{'-' * -@b}<]>"
                    else
                        "#{'+' * @a}[->#{'+' * @b}<]>"
                end

                code2 = case
                    when @c < 0
                        "#{'-' * -@c}"
                    when @c > 0
                        "#{'+' * @c}"
                    else
                        ''
                end

                "#{code1}#{code2}."
            end

            private

            def calculate_n(a, b, c)
                a * b + c
            end

            def calculate_code_length(a, b, c)
                code1_length =
                    if a == 0 || b == 0
                        0
                    else
                        a + 3 + b.abs + 3
                    end
                code2_length =
                    if c == 0
                        0
                    else
                        c.abs
                    end
                code1_length + code2_length
            end

        end

    end

end

