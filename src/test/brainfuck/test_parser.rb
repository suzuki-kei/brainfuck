require_relative 'base'
require 'brainfuck/parser'

module Brainfuck

    class ParserTestCase < TestCase

        def test_parse
            source_code = <<~'EOS'
                # H
                ++++++++[->+++++++++<]>.
                # e
                <++++[->+++++++<]>+.
                # l
                +++++++.
                # l
                .
                # o
                +++.
            EOS
            expected = '++++++++[->+++++++++<]>.<++++[->+++++++<]>+.+++++++..+++.'
            actual = Brainfuck::Parser.new.parse(source_code)
            assert_equal expected, actual
        end

        [
            'あ',
            '>あ',
            'あ<',
            'テスト',
            '>テ+ス+ト<',
        ].each.with_index do |source_code, index|
            define_method("test_parse_raises_ParseError_when_source_code_includes_non_ascii_character_#{index + 1}") do
                assert_raises(Brainfuck::ParseError) do
                    Brainfuck::Parser.new.parse(source_code)
                end
            end
        end

        [
            '[',
            ']',
        ].each.with_index do |source_code, index|
            define_method("test_parse_raises_SyntaxError_when_unmatched_brackets_exists_#{index + 1}") do
                assert_raises(Brainfuck::SyntaxError) do
                    Brainfuck::Parser.new.parse(source_code)
                end
            end
        end

    end

end

