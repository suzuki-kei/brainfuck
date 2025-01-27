require 'brainfuck/parser'

File.basename($0, '.rb').sub('main.', '').tap do |name|
    require "brainfuck/#{name}"
    GENERATOR_CLASS = Brainfuck.const_get(name.capitalize)
end

begin
    text = ARGF.read
    generator = GENERATOR_CLASS.new
    code = generator.generate(text)
    puts Brainfuck::Parser.new.parse(code).size
    puts code
rescue Interrupt
    # ignore
end

