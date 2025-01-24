require_relative 'brainfuck/errors'
require_relative 'brainfuck/specification'
require_relative 'brainfuck/virtual_machine'
require_relative 'brainfuck/parser'

def main
    source_code = ARGF.read
    vm = Brainfuck::VirtualMachine.new
    vm.execute(source_code)
rescue Interrupt
    # ignore
end

main if $0 == __FILE__

