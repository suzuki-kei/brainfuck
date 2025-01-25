module Brainfuck

    class Generator3

        def generate(text)
            map = generate_map
            chars = text.chars.map(&:ord)
            codes = generate_codes(chars, map)
            codes.join("\n")
        end

        private

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
                        a + 3 + b + 3
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

        def generate_map
            {}.tap do |map|
                (0..255).each do |a|
                    (0..255).each do |b|
                        if a * b > 255
                            break
                        end

                        code = Code.new(a, b, 0)
                        shortest_code = map.fetch(code.n, code)
                        map[code.n] = code if code.code_length <= shortest_code.code_length

                        (-255..255).each do |c|
                            if a * b + c < -255 || 255 < a * b + c
                                break
                            end

                            code = Code.new(a, b, c)
                            shortest_code = map.fetch(code.n, code)
                            map[code.n] = code if code.code_length <= shortest_code.code_length
                        end
                    end
                end
            end
        end

        def generate_codes(chars, map)
            chars.zip([nil, *chars]).map do |n, previous_n|
                if previous_n.nil?
                    map[n].generate
                else
                    code1 = map[n]
                    code2 = map[n - previous_n]

                    if code1.code_length < code2.code_length
                        ">#{code1.generate}"
                    else
                        if code2.generate.include?('[')
                            "<#{code2.generate}"
                        else
                            "#{code2.generate}"
                        end
                    end
                end
            end
        end

    end

end

