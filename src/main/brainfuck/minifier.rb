require_relative 'parser'

module Brainfuck

    class Minifier

        def minify(text, keep_newline: false)
            Parser.new.parse(text)
        end

    end

end

