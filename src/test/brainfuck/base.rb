require 'stringio'
require 'test/unit'

module Brainfuck

    class TestCase < Test::Unit::TestCase

        ROOT_DIR = File.absolute_path(File.join(File.dirname(__FILE__), '..', '..', '..'))

        def capture_stdin(stdin)
            original_stdin = $stdin
            $stdin = StringIO.new(stdin.clone, 'r')
            yield
        ensure
            $stdin = original_stdin
        end

        def capture_stdout
            original_stdout = $stdout
            $stdout = StringIO.new
            yield
            $stdout.string
        ensure
            $stdout = original_stdout
        end

    end

end

