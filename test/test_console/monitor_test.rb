require 'test_helper'

class TestConsole::MonitorTest < ActionView::TestCase

  include TestConsole::Monitor

  describe TestConsole::Monitor do
    setup do
      FakeFS.activate!
    end

    teardown do
      FakeFS.deactivate!
    end

    describe '#stop_folders_changed?' do
    end

    describe '#file_changed?' do
      setup do
        @path = 'some_file'
        @time = Time.now
      end

      context 'when the file does not exist' do
        should 'return false' do
          assert_false file_changed? @path, @time
        end
      end

      context 'when the file does exist' do
        setup do
          FileUtils.touch @path
        end

        teardown do
          FileUtils.rm @path
        end

        context 'when a date or time is passed as the second parameter' do
          context 'and it is later than the last modified time of the file' do
            setup do
              @time = Time.now + 10.minutes
            end

            should 'return false' do
              assert_false file_changed? @path, @time
            end
          end
          context 'and it is earlier than the last modified time of the file' do
            setup do
              @time = Time.now - 10.minutes
            end
            should 'return true' do
              assert file_changed? @path, @time
            end
          end
        end
      end
    end

  end
end
