require 'brainfuck/virtual_machine'

def main
    source_code = ARGF.read
    vm = Brainfuck::VirtualMachine.new
    vm.execute(source_code)
rescue Interrupt
    # ignore
end

main if $0 == __FILE__

