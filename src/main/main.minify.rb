require 'brainfuck/parser'

def main
    source_code = ARGF.read
    parser = Brainfuck::Parser.new
    $stdout.write(parser.parse(source_code))
rescue Interrupt
    # ignore
end

main if $0 == __FILE__

