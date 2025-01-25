File.basename(__FILE__, '.rb').sub('main.', '').tap do |name|
    require "brainfuck/#{name}"
    GENERATOR_CLASS = Brainfuck.const_get(name.capitalize)
end

def main
    text = ARGF.read
    generator = GENERATOR_CLASS.new
    puts generator.generate(text)
rescue Interrupt
    # ignore
end

main if $0 == __FILE__

