require_relative 'code'

module Brainfuck

    module CodeMap

        extend(self)

        def generate(range)
            {}.tap do |map|
                range_n = range
                range_c = [range.min, -14].max .. [range.max, 14].min
                generate_codes(map, range_n, range_c, [], 3)
            end
        end

        private

        def generate_codes(map, range_n, range_c, ms, depth)
            if depth == 0
                generate_code2s(map, range_n, range_c, ms)
            else
                range_mn.each do |m|
                    next_ms = ms + [m]
                    product = next_ms.reduce(&:*)
                    next unless range_n.cover?(product + 14) || range_n.cover?(product - 14)
                    generate_codes(map, range_n, range_c, next_ms, 0)
                end
                range_mx.each do |m|
                    next_ms = ms + [m]
                    product = next_ms.reduce(&:*)
                    next unless range_n.cover?(product + 14) || range_n.cover?(product - 14)
                    generate_codes(map, range_n, range_c, next_ms, depth - 1)
                end
            end
        end

        def generate_code2s(map, range_n, range_c, ms)
            range_c.each do |c|
                next unless ms.size < 2 || range_n.cover?(ms.reduce(&:*) + c)
                code = Code.new(ms, c)
                shortest_code = map.fetch(code.n, code)
                map[code.n] = [shortest_code, code].min_by(&:size)
            end
        end

        # "n = m1 * m2 * ... * mn + c" における m1 が取り得る範囲
        def range_m1
            0..14
        end

        # "n = m1 * m2 * ... * mn + c" における m1, mn 以外が取り得る範囲
        def range_mx
            1..14
        end

        # "n = m1 * m2 * ... * mn + c" における mn が取り得る範囲
        def range_mn
            (-14..-1).chain(1..14)
        end

    end

end

