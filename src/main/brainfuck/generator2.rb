module Brainfuck

    class Generator2

        def generate(text)
            chars = text.chars.map(&:ord)
            codes = generate_codes(chars)
            codes.join("\n")
        end

        private

        def generate_codes(chars)
            chars.zip([nil, *chars]).map do |n, previous_n|
                case
                    when previous_n.nil?
                        "#{'+' * n}."
                    when n == previous_n
                        '.'
                    when n < previous_n && previous_n - n <= n
                        "#{'-' * (previous_n - n)}."
                    when n > previous_n && n - previous_n <= n
                        "#{'+' * (n - previous_n)}."
                    else
                        ">#{'+' * n}."
                end
            end
        end

    end

end

