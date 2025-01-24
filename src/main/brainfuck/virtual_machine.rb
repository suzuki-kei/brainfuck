require_relative 'errors'
require_relative 'parser'
require_relative 'specification'

module Brainfuck

    class VirtualMachine

        include Specification

        def initialize
            @cells = [0] * NUMBER_OF_CELLS
            @cells_index = 0
            @max_cells_index = 0
        end

        #
        # ソースコードを実行する.
        #
        # ==== 引数
        # source_code::
        #     実行するソースコード.
        #
        # ==== 戻り値
        # 常に nil.
        #
        # ==== 例外
        # CommandError::
        #     '+', '-' によってセルの値が範囲外になる場合.
        #     もしくは, ポインタがセル配列の範囲外に達する場合.
        #
        def execute(source_code)
            nil.tap do
                @commands = Parser.new.parse(source_code).freeze
                @commands_index = 0
                execute_current_command until finished?
            end
        end

        #
        # セルの配列.
        #
        # ==== 戻り値
        # セルの配列.
        # 内部状態を複製した値のため, 戻り値を変更しても VirtualMachine には影響しない.
        #
        def cells
            @cells.clone
        end

        #
        # 使用済みセルの配列.
        #
        # '<', '>' コマンドでポインタが到達したことのあるセルが使用済みセルとなる.
        # 例えば, execute('>>') を実行すると先頭から 3 つのセルが使用済みセルとなる.
        #
        # ==== 戻り値
        # 使用済みセルの配列.
        # 内部状態を複製した値のため, 戻り値を変更しても VirtualMachine には影響しない.
        #
        def used_cells
            @cells[..@max_cells_index]
        end

        private

        COMMAND_TO_METHOD_MAP = {
            '+' => :execute_command_increment,
            '-' => :execute_command_decrement,
            '>' => :execute_command_move_right,
            '<' => :execute_command_move_left,
            '[' => :execute_command_opening_bracket,
            ']' => :execute_command_closing_bracket,
            '.' => :execute_command_output,
            ',' => :execute_command_input,
        }.freeze

        def finished?
            @commands_index == @commands.size
        end

        def execute_current_command
            command = @commands[@commands_index]
            method_name = COMMAND_TO_METHOD_MAP.fetch(command, :execute_command_ignore)
            method(method_name).call
        end

        def execute_command_increment
            if @cells[@cells_index] == MAX_CELL_VALUE
                raise CommandError, 'cell holds maximum value'
            end

            @cells[@cells_index] += 1
            @commands_index += 1
        end

        def execute_command_decrement
            if @cells[@cells_index] == MIN_CELL_VALUE
                raise CommandError, 'cell holds minimum value'
            end

            @cells[@cells_index] -= 1
            @commands_index += 1
        end

        def execute_command_move_right
            if @cells_index == @cells.size - 1
                raise CommandError, 'pointer is rightmost'
            end

            @cells_index += 1
            @commands_index += 1
            @max_cells_index = @cells_index if @max_cells_index < @cells_index
        end

        def execute_command_move_left
            if @cells_index == 0
                raise CommandError, 'pointer is leftmost'
            end

            @cells_index -= 1
            @commands_index += 1
        end

        def execute_command_opening_bracket
            if @cells[@cells_index] != 0
                @commands_index += 1
                return
            end

            @commands_index += 1
            bracket_nesting_depth = 1

            while bracket_nesting_depth > 0
                bracket_nesting_depth += 1 if @commands[@commands_index] == '['
                bracket_nesting_depth -= 1 if @commands[@commands_index] == ']'
                @commands_index += 1 if bracket_nesting_depth > 0
            end
        end

        def execute_command_closing_bracket
            if @cells[@cells_index] == 0
                @commands_index += 1
                return
            end

            @commands_index -= 1
            bracket_nesting_depth = 1

            while bracket_nesting_depth > 0
                bracket_nesting_depth -= 1 if @commands[@commands_index] == '['
                bracket_nesting_depth += 1 if @commands[@commands_index] == ']'
                @commands_index -= 1 if bracket_nesting_depth > 0
            end
        end

        def execute_command_output
            $stdout.putc(@cells[@cells_index])
            @commands_index += 1
        end

        def execute_command_input
            c = $stdin.read(1)
            @cells[@cells_index] = c.ord unless c.nil?
            @commands_index += 1
        end

        def execute_command_ignore
            @commands_index += 1
        end

    end

end

