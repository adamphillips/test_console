require 'test_helper'
require 'fakefs/safe'
require 'readline'

class TestConsole::HistoryTest < ActiveSupport::TestCase

  context 'read' do
    context 'when a file exists at the specified location' do
      setup do
        FakeFS.activate!
        FileUtils.mkdir_p File.dirname(TestConsole::History::LOCATION)
        File.open(TestConsole::History::LOCATION, 'w') do |file|
          Marshal.dump(['cmd', '123', 'abc'], file)
        end
      end

      teardown do
        FakeFS.deactivate!
      end

      should 'read the file and load the lines from the history into the readline history' do
        # Note that there is an issue with the Readline history in that the first item never appears
        # http://bogojoker.com/readline/#libedit_history_issue
        assert File.exists?(TestConsole::History::LOCATION)
        TestConsole::History.read
        assert_equal ['123', 'abc'], Readline::HISTORY.to_a
      end
    end
  end

end
