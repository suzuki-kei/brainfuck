require_relative 'code_operations'

module Brainfuck

    #
    # "n = m1 * m2 * ... * mN + c" 形式で値を生成するコード.
    #
    # 掛け算が 0 回の場合のコード例:
    #     N   ++
    #
    # 掛け算が 1 回の場合のコード例 (掛け算部分の結果が 0 になるため無意味):
    #     N   >
    #     A   ++
    #     A   [
    #     A       -
    #     A   ]
    #     A   <
    #     N   ++++
    #
    # 掛け算が 2 回の場合のコード例:
    #     N   >
    #     A   ++
    #     A   [
    #     A       -
    #     A       <
    #     N       +++
    #     N       >
    #     A   ]
    #     A   <
    #     N   ++++
    #
    # 掛け算が 3 回の場合のコード例:
    #     N   >
    #     A   ++
    #     A   [
    #     A       -
    #     A       >
    #     B       +++
    #     B       [
    #     B           -
    #     B           <<
    #     N           ++++
    #     B           >>
    #     B       ]
    #     B       <
    #     A   ]
    #     A   <
    #     N   +++++
    #
    class Code

        attr_reader :n, :ms, :c

        def initialize(ms, c)
            @n, @ms, @c = CodeOperations.parse(ms, c)
        end

        def to_s
            inspect
        end

        def inspect
            "#{self.class.name}(n=#{@n}, ms=[#{ms.join(', ')}], c=#{@c}, size=#{size}, code='#{generate}')"
        end

        def size
            [
                CodeOperations.compute_code1_size(@ms),
                CodeOperations.compute_code2_size(@ms, @c),
            ].sum
        end

        def generate
            [
                CodeOperations.generate_code1(@ms),
                CodeOperations.generate_code2(@ms, @c),
            ].join
        end

    end

end

