require_relative 'code_map'
require_relative 'specification'

module Brainfuck

    class OutputStringGenerator3

        include Specification

        def initialize
            @code_map = CodeMap.generate(MIN_CELL_VALUE..MAX_CELL_VALUE)
        end

        def generate(text)
            ns = text.chars.map(&:ord)
            codes = generate_codes(ns)
            codes.join("\n")
        end

        private

        def generate_codes(ns)
            ns.zip([nil, *ns]).map do |n, previous_n|
                if previous_n.nil?
                    "#{@code_map[n].generate}."
                else
                    code1 = @code_map[n]
                    code2 = @code_map[n - previous_n]

                    if code1.size < code2.size
                        ">#{code1.generate}."
                    else
                        "#{code2.generate}."
                    end
                end
            end
        end

    end

end

