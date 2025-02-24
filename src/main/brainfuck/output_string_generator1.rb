module Brainfuck

    class OutputStringGenerator1

        def generate(text)
            ns = text.chars.map(&:ord)
            codes = generate_codes(ns)
            codes.join(">\n")
        end

        private

        def generate_codes(ns)
            ns.map do |n|
                "#{'+' * n}."
            end
        end

    end

end

