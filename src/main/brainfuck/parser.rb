require_relative 'specification'

module Brainfuck

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
            validate_all_brackets_are_matched(source_code)
            commands_from_source_code(source_code)
        end

        private

        def validate_contains_only_ascii_characters(source_code)
            unless source_code.ascii_only?
                raise ParseError, 'non-ASCII character included'
            end
        end

        def validate_all_brackets_are_matched(source_code)
            bracket_nesting_depth = 0

            source_code.chars.each do |command|
                bracket_nesting_depth += 1 if command == '['
                bracket_nesting_depth -= 1 if command == ']'

                if bracket_nesting_depth < 0
                    raise SyntaxError, 'unmatched brackets exists'
                end
            end

            if bracket_nesting_depth != 0
                raise SyntaxError, 'unmatched brackets exists'
            end
        end

        def commands_from_source_code(source_code)
            source_code.chars.select(&COMMANDS.method(:include?)).join.freeze
        end

    end

end

