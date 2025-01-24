module Brainfuck

    BrainfackError = Class.new(StandardError)
    ParseError = Class.new(BrainfackError)
    SyntaxError = Class.new(BrainfackError)
    CommandError = Class.new(BrainfackError)

end

