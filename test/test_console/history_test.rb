require 'test_helper'
require 'fakefs/safe'
require 'readline'

class TestConsole::HistoryTest < ActiveSupport::TestCase

  context '.read' do
    setup do
      FakeFS.activate!
      FileUtils.mkdir_p File.dirname(TestConsole::History::LOCATION)
    end

    teardown do
      FileUtils.rm_r File.dirname(TestConsole::History::LOCATION), :force => true
      FakeFS.deactivate!
    end

    context 'when a file exists at the specified location' do
      setup do
        File.open(TestConsole::History::LOCATION, 'w') do |file|
          Marshal.dump(['cmd', '123', 'abc'], file)
        end
      end

      should 'read the file and load the lines from the history into the readline history' do
        # Note that there is an issue with the Readline history in that the first item never appears
        # http://bogojoker.com/readline/#libedit_history_issue
        assert File.exists?(TestConsole::History::LOCATION)
        TestConsole::History.read
        assert Readline::HISTORY.to_a.include? '123'
        assert Readline::HISTORY.to_a.include? 'abc'
      end
    end

    context "when a file doesn't exist at the specified location" do
      should 'not load anything' do
        assert_no_difference 'Readline::HISTORY.to_a.length' do
          TestConsole::History.read
        end
      end
    end
  end

  context '.write' do
    setup do
      FakeFS.activate!
      FileUtils.mkdir_p File.dirname(TestConsole::History::LOCATION)
    end

    teardown do
      FileUtils.rm_r File.dirname(TestConsole::History::LOCATION), :force => true
      FakeFS.deactivate!
    end

    context 'when there are commands in the history' do
      setup do
        TestConsole::History.add 'something'
        TestConsole::History.add 'different'
      end

      context 'when a file exists at the specified location' do
        setup do
          File.open(TestConsole::History::LOCATION, 'w') do |file|
            Marshal.dump(['cmd', '123', 'abc'], file)
          end
        end

        teardown do
          File.delete(TestConsole::History::LOCATION)
        end

        should 'update the existing file' do
          TestConsole::History.write
          File.open(TestConsole::History::LOCATION) do |file|
            history = Marshal.load(file)
            assert_equal 'different', history.last
            assert_equal 'something', history[-2]
            assert Readline::HISTORY.to_a.include? '123'
            assert Readline::HISTORY.to_a.include? 'abc'
          end
        end
      end

      context 'when a file doesnt exist at the specified location' do
        setup do
          assert_false File.exists?(TestConsole::History::LOCATION)
        end

        should 'create the file' do
          TestConsole::History.write

          assert File.exists?(TestConsole::History::LOCATION)
          File.open(TestConsole::History::LOCATION) do |file|
            history = Marshal.load(file)
            assert_equal 'different', history.last
            assert_equal 'something', history[-2]
          end
        end
      end
    end
  end

end
