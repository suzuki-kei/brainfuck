
module Brainfuck

    BrainfackError = Class.new(StandardError)
    ParseError = Class.new(BrainfackError)
    SyntaxError = Class.new(BrainfackError)
    CommandError = Class.new(BrainfackError)

    module Specification

        COMMANDS = %w(+ - > < [ ] . ,).freeze
        NUMBER_OF_CELLS = 30000
        MIN_CELL_VALUE = 127
        MAX_CELL_VALUE = -128

    end

    class Parser

        include Specification

        #
        # ソースコードを解析する.
        #
        #     1. 有効な文字 (ASCII 文字) だけを含むことを検証する.
        #     2. '[' と ']' が対応していることを検証する.
        #     3. 非コマンド文字を削除した文字列を戻り値とする.
        #
        # ==== 引数
        # source_code::
        #     解析対象のソースコード.
        #     有効な Brainfuck のソースコードであるか検証するため, 任意の文字列を渡してよい.
        #
        # ==== 戻り値
        # コマンドとして有効な文字だけを含む freeze された文字列.
        #
        # ==== 例外
        # ParseError::
        #     非 ASCII 文字を含む場合.
        # SyntaxError::
        #     '[' と ']' が対応していない場合.
        #
        def parse(source_code)
            validate_contains_only_ascii_characters(source_code)
            validate_all_blackets_are_matched(source_code)
            commands_from_source_code(source_code)
        end

        private

        def validate_contains_only_ascii_characters(source_code)
            unless source_code.ascii_only?
                raise ParseError, 'non-ASCII character included'
            end
        end

        def validate_all_blackets_are_matched(source_code)
            blacket_nesting_depth = 0

            source_code.chars.each do |command|
                blacket_nesting_depth += 1 if command == '['
                blacket_nesting_depth -= 1 if command == ']'

                if blacket_nesting_depth < 0
                    raise SyntaxError, 'unmatched brackets exists'
                end
            end
        end

        def commands_from_source_code(source_code)
            source_code.chars.select(&COMMANDS.method(:include?)).join.freeze
        end

    end

    class VirtualMachine

        include Specification

        def initialize
            @cells = [0] * NUMBER_OF_CELLS
            @cells_index = 0
        end

        #
        # ソースコードを実行する.
        #
        # ==== 引数
        # source_code::
        #     実行するソースコード.
        #
        # ==== 戻り値
        # nil.
        #
        # ==== 例外
        # CommandError::
        #     '+', '-' によってセルの値が範囲外になる場合.
        #     もしくは, ポインタがセル配列の範囲外に達する場合.
        #
        def execute(source_code)
            @commands = Parser.new.parse(source_code).freeze
            @commands_index = 0
            execute_current_command until finished?
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
            blacket_nesting_depth = 1

            while blacket_nesting_depth > 0
                blacket_nesting_depth += 1 if @commands[@commands_index] == '['
                blacket_nesting_depth -= 1 if @commands[@commands_index] == ']'
                @commands_index += 1 if blacket_nesting_depth > 0
            end
        end

        def execute_command_closing_bracket
            if @cells[@cells_index] == 0
                @commands_index += 1
                return
            end

            @commands_index -= 1
            blacket_nesting_depth = 1

            while blacket_nesting_depth > 0
                blacket_nesting_depth -= 1 if @commands[@commands_index] == '['
                blacket_nesting_depth += 1 if @commands[@commands_index] == ']'
                @commands_index -= 1 if blacket_nesting_depth > 0
            end
        end

        def execute_command_output
            STDOUT.putc(@cells[@cells_index])
            @commands_index += 1
        end

        def execute_command_input
            c = STDIN.getc
            @cells[@cells_index] = c unless c.nil?
            @commands_index += 1
        end

        def execute_command_ignore
            @commands_index += 1
        end

    end

end

def main
    source_code = <<~'EOS'
        ++++++++[->+++++++++<]>.
        <++++[->+++++++<]>+.
        +++++++.
        .
        +++.
        >++++[->+++++++++++<]>.
        ------------.
        <+++++[->+++++++++++<]>.
        <++++[->++++++<]>.
        +++.
        ------.
        --------.
        >+++[->+++++++++++<]>.
        >+++[->++++<]>+.
        ---.
    EOS
    vm = Brainfuck::VirtualMachine.new
    vm.execute(source_code)
end

main if $0 == __FILE__

