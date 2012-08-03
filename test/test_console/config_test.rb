require 'test_helper'

class TestConsole::ConfigTest < ActiveSupport::TestCase
  describe TestConsole do
    describe '#commands' do
      context 'when passed a command type that exists' do
        setup do
          assert_not_nil TestConsole::Config.run_commands
        end
        should 'return the configured commands of that type' do
          assert_equal TestConsole.commands(:run), TestConsole::Config.run_commands
        end
      end
    end

    describe '#setup' do
      context 'when passed a block' do
        context 'setting config variables' do
          setup do
            @old_run_commands = TestConsole::Config.run_commands
            TestConsole.setup do |config|
              config.run_commands = ['arretez']
            end
          end
          teardown do
            TestConsole.setup do |config|
              config.run_commands = @old_run_commands
            end
          end
          should 'update the config variables' do
            assert_equal ['arretez'], TestConsole::Config.run_commands
          end
        end
      end
    end
  end

  describe TestConsole::Config do
    context 'on startup' do
      should 'set the :app_root config setting' do
        assert_config :app_root, TestConsole::Config.send(:find_app_root)
      end
    end

    describe '.find_app_root' do
      setup do
        FakeFS.activate!
      end

      teardown do
        FakeFS.deactivate!
      end

      context 'when the current folder contains a Gemfile' do
        setup do
          FileUtils.touch 'Gemfile'
        end

        teardown do
          FileUtils.rm 'Gemfile'
        end

        should 'return the absolute path to the folder' do
          folder = TestConsole::Config.send :find_app_root
          assert_equal Dir.pwd, folder
        end
      end

      context 'when the current folder has a parent folder containing a Gemfile' do
        context 'one level above' do
          setup do
            FileUtils.touch '../Gemfile'
            @path = Pathname.new('..').realpath.to_s
          end

          teardown do
            FileUtils.rm '../Gemfile'
          end

          should 'return the absolute path to the folder' do
            assert_equal @path, TestConsole::Config.send(:find_app_root)
          end
        end

        context 'two levels above' do
          setup do
            FileUtils.touch '../../Gemfile'
            @path = Pathname.new('../..').realpath.to_s
          end

          teardown do
            FileUtils.rm '../../Gemfile'
          end

          should 'return the absolute path to the folder' do
            assert_equal @path, TestConsole::Config.send(:find_app_root)
          end

        end
      end

      context 'when none of the parent folders contain a Gemfile' do
        should 'return the current folder' do
          assert_equal Pathname.new('.').realpath.to_s, TestConsole::Config.send(:find_app_root)
        end
      end

    end
  end
end
