require_relative 'code_map'
require_relative 'specification'

module Brainfuck

    class BuildStringGenerator

        include Specification

        def generate(text)
            ns = text.chars.map(&:ord)
            codes = ns.map{|n| code_map[n].generate}
            codes = codes.map{|code| "#{code}>".gsub(/<>$/, '')}
            codes.join("\n")
        end

        private

        def code_map
            @@map ||= CodeMap.generate(MIN_CELL_VALUE..MAX_CELL_VALUE)
        end

    end

end

