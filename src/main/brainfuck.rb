Dir.glob(File.absolute_path(__FILE__).sub(/\.rb$/, "#{File::SEPARATOR}*.rb")).each(&method(:require))

def main
    source_code = ARGF.read
    vm = Brainfuck::VirtualMachine.new
    vm.execute(source_code)
rescue Interrupt
    # ignore
end

main if $0 == __FILE__

