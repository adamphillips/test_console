require 'test_helper'
require 'fakefs/safe'
require 'readline'

class TestConsole::HistoryTest < ActiveSupport::TestCase

  context 'read' do
    context 'when a file exists at the specified location' do
      setup do
        FakeFS.activate!
        FileUtils.mkdir_p File.dirname(TestConsole::History::LOCATION)
        File.open(TestConsole::History::LOCATION, 'w+') do |file|
          Marshal.dump(['a command'], file)
        end
      end

      teardown do
        FakeFS.deactivate!
      end

      should 'read the file and load the lines from the history into the readline history' do
        assert File.exists?(TestConsole::History::LOCATION)
        TestConsole::History.read
        assert_equal 'a command', Readline::HISTORY.to_a.last
      end
    end
  end

end
