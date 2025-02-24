require 'open3'
require_relative 'base'

module Brainfuck

    # ./src/scripts/ 以下のスクリプトのテスト.
    # 意図せず起動しなくなることを検知できる程度の簡単な確認をおこなう.
    class ScriptsTestCase < TestCase

        SCRIPTS_DIR = File.join(ROOT_DIR, 'src', 'scripts')

        def test_demonstrate_generators
            Dir.chdir(SCRIPTS_DIR) do
                stdout, stderr, status = Open3.capture3('bash demonstrate-output-string-generators.sh')
                assert_equal 0, status.exitstatus
            end
        end

    end

end

