module Brainfuck

    class OutputStringGenerator2

        def generate(text)
            ns = text.chars.map(&:ord)
            codes = generate_codes(ns)
            codes.join("\n")
        end

        private

        def generate_codes(ns)
            ns.zip([nil, *ns]).map do |n, previous_n|
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

