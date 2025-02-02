require 'brainfuck/errors'
require 'brainfuck/virtual_machine'

def main
    source_code = ARGF.read
    vm = Brainfuck::VirtualMachine.new
    vm.execute(source_code)
rescue Brainfuck::BrainfuckError => error
    $stderr.puts "#{error.class.name.split('::').last} - #{error.to_s}"
    exit(1)
rescue Interrupt
    # ignore
end

main if $0 == __FILE__

