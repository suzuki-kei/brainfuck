
module Brainfuck

    module CodeOperations

        extend(self)

        def parse(ms, c)
            [compute_n(ms, c), ms, c]
        end

        def compute_n(ms, c)
            if (0 ... ms.size - 1).any?{|i| ms[i] < 0}
                raise ArgumentError, "ms=[#{ms}], c=#{c}"
            end

            if ms.size < 2
                c
            else
                ms.reduce(&:*) + c
            end
        end

        def compute_code1_size(ms, i=0)
            case
                when ms.size < 2 || ms.any?(&:zero?)
                    0
                when i == 0
                    1 + ms[i] + compute_code1_size(ms, i + 1)
                when i != ms.size - 1
                    3 + ms[i].abs + compute_code1_size(ms, i + 1) + 2
                else
                    2 + i + ms[i].abs + i + 1
            end
        end

        def generate_code1(ms, i=0)
            case
                when ms.size < 2 || ms.any?(&:zero?)
                    ''
                when i == 0
                    ">#{'+' * ms[i]}#{generate_code1(ms, i + 1)}"
                when i != ms.size - 1
                    "[->#{(ms[i] < 0 ? '-' : '+') * ms[i].abs}#{generate_code1(ms, i + 1)}<]"
                else
                    "[-#{'<' * i}#{(ms[i] < 0 ? '-' : '+') * ms[i].abs}#{'>' * i}]"
            end
        end

        def compute_code2_size(ms, c)
            if ms.size < 2 || ms.any?(&:zero?)
                c.abs
            else
                1 + c.abs
            end
        end

        def generate_code2(ms, c)
            if ms.size < 2 || ms.any?(&:zero?)
                "#{(c < 0 ? '-' : '+') * c.abs}"
            else
                "<#{(c < 0 ? '-' : '+') * c.abs}"
            end
        end

    end

end

