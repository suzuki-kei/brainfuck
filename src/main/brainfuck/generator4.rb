require_relative 'virtual_machine'

module Brainfuck

    class Generator4

        def generate(text)
            ns = text.chars.map(&:ord)
            codes = generate_codes(ns)
            codes.join("\n")
        end

        private

        def generate_codes(ns)
            code1 = Code1Generator.new.generate(ns)
            code2 = Code2Generator.new.generate(ns, code1)
            [code1, code2]
        end

        class Code1Generator

            def generate(ns)
                <<~'EOS'.strip
                    +++++
                    [
                        -
                        >
                        >+++
                        >+++++++
                        >++++++++++++
                        >++++++++++++++++++++
                        [+++<]
                        <
                    ]
                EOS
            end

        end

        class Code2Generator

            def generate(ns, code1)
                code2s = []
                cells = generate_initial_cells(code1)
                cells_index = 0

                ns.each do |n|
                    i = find_destination_index(n, cells, cells_index)
                    move_pointer_code = generate_move_pointer_code(i, cells_index)
                    update_cell_code = generate_update_cell_code(n, i, cells)

                    cells[i] = n
                    cells_index = i
                    code2s << move_pointer_code + update_cell_code + '.'
                end

                code2s.join("\n")
            end

            private

            def generate_initial_cells(code1)
                vm = VirtualMachine.new
                vm.execute(code1)
                vm.used_cells
            end

            def find_destination_index(n, cells, cells_index)
                (0 .. cells.size - 1).min_by do |i|
                    (cells[i] - n).abs + (cells_index - i).abs
                end
            end

            def generate_move_pointer_code(i, cells_index)
                case
                    when cells_index < i
                        '>' * (i - cells_index)
                    when cells_index > i
                        '<' * (cells_index - i)
                    else
                        ''
                end
            end

            def generate_update_cell_code(n, i, cells)
                case
                    when cells[i] < n
                        '+' * (n - cells[i])
                    when cells[i] > n
                        '-' * (cells[i] - n)
                    else
                        ''
                end
            end

        end

    end

end

