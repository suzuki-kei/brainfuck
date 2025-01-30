require 'brainfuck/character_to_code_map'

def main
    map = Brainfuck::CharacterToCodeMap.new
    map.dump
rescue Interrupt
    # ignore
end

main if $0 == __FILE__

