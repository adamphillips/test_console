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

    describe '#stop_folders_changed?' do
      setup do
        TestConsole.setup do |config|
          config.stop_folders << 'test_config'
        end

        @path = 'test_config/something/config.rb'
        FileUtils.mkdir_p 'test_config/something'
        FileUtils.touch @path
      end

      teardown do
        FileUtils.rm_r 'test_config'
      end

      context 'when the file has not been changed since @last_init_time' do
        setup do
          @last_init_time = Time.now + 1.year
        end

        should 'return false' do
          assert_false stop_folders_changed?
        end
      end

      context 'when the file has been changed since @last_init_time' do
        setup do
          @last_init_time = Time.now - 1.year
        end

        should 'return true' do
          assert stop_folders_changed?
        end
      end
    end

    describe '#views_changed?' do
      setup do
        TestConsole.setup do |config|
          config.view_folders << 'test_views'
        end

        @path = 'test_views/view.html.erb'
        FileUtils.mkdir_p 'test_views'
        FileUtils.touch @path
      end

      teardown do
        FileUtils.rm_r 'test_views'
      end

      context 'when the file has not been changed since @last_run_time' do
        setup do
          @last_run_time = Time.now + 1.year
        end

        should 'return false' do
          assert_false views_changed?
        end
      end

      context 'when the file has been changed since @last_run_time' do
        setup do
          @last_run_time = Time.now - 1.year
        end

        should 'return true' do
          assert views_changed?
        end
      end
    end

  end
end
