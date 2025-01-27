require_relative 'character_to_code_map'

module Brainfuck

    class Generator3

        def initialize
            @map = CharacterToCodeMap.new
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
                    @map[n].generate
                else
                    code1 = @map[n]
                    code2 = @map[n - previous_n]

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

