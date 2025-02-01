module Brainfuck

    BrainfuckError = Class.new(StandardError)
    ParseError = Class.new(BrainfuckError)
    SyntaxError = Class.new(BrainfuckError)
    CommandError = Class.new(BrainfuckError)

end

