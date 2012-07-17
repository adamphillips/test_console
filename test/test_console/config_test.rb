class TestConsole::ConfigTest < ActiveSupport::TestCase
  describe_class TestConsole do
    describe_method '#commands' do
      context 'when passed a command type that exists' do
        setup do
          assert_not_nil TestConsole::Config.run_commands
        end
        should 'return the configured commands of that type' do
          assert_equal TestConsole.commands(:run), TestConsole::Config.run_commands
        end
      end
    end

    describe_method '#setup' do
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
end
