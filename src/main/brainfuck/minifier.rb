require_relative 'specification'

module Brainfuck

    class Minifier

        include Specification

        def minify(text, keep_format: false)
            if keep_format
                lines = text.lines.map(&:chomp)
                lines = remove_lines_not_contains_command_characters(lines)
                lines = lines.map(&method(:replace_non_command_characters_to_spaces))
                lines = lines.map(&method(:remove_non_command_characters_other_than_indentation))
                lines = dedent(lines)
                lines.join("\n")
            else
                text.gsub(NON_COMMAND_REGEXP, '')
            end
        end

        private

        COMMAND_REGEXP = /[#{COMMANDS.map(&Regexp.method(:escape)).join}]/

        NON_COMMAND_REGEXP = /[^#{COMMANDS.map(&Regexp.method(:escape)).join}]/

        def remove_lines_not_contains_command_characters(lines)
            lines.select {|line| line =~ COMMAND_REGEXP}
        end

        def replace_non_command_characters_to_spaces(line)
            line.gsub(NON_COMMAND_REGEXP, ' ')
        end

        def remove_non_command_characters_other_than_indentation(line)
            line =~ /^( *)(.*)$/
            "#{$1}#{$2.gsub(NON_COMMAND_REGEXP, '')}"
        end

        def dedent(lines)
            offset = lines.map {|line| line.index(/[^ ]/) || 0}.min
            lines.map {|line| line[offset..]}
        end

    end

end

