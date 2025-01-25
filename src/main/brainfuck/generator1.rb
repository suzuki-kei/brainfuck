module Brainfuck

    class Generator1

        def generate(text)
            chars = text.chars.map(&:ord)
            codes = generate_codes(chars)
            codes.join(">\n")
        end

        private

        def generate_codes(chars)
            chars.map do |n|
                "#{'+' * n}."
            end
        end

    end

end

