require 'brainfuck/generator'

GENERATOR_CLASS = Brainfuck.const_get(File.basename(__FILE__, '.rb').sub('main.', '').capitalize)

def main
    text = ARGF.read
    generator = GENERATOR_CLASS.new
    puts generator.generate(text)
rescue Interrupt
    # ignore
end

main if $0 == __FILE__

