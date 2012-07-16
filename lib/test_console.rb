require 'test_console/history'
require 'test_console/utility'

require 'test_console/builder'
require 'test_console/cli_parser'
require 'test_console/colors'
require 'test_console/help'
require 'test_console/monitor'
require 'test_console/output'
require 'test_console/runner'

require 'action_view/resolver'

module TestConsole

  WATCH_PATHS = ['test/support', 'lib', 'app/models', 'app/controllers', 'app/helpers', 'app/presenters']
  VIEW_FOLDERS = ['app/views']
  # These are folders that mean the test console need to be reloaded if any files in them are modified.
  # The file types checked are .rb and .yml
  STOP_FOLDERS = ['test/fixtures', 'config/environments']

  QUIT_COMMANDS = ['quit', 'q', 'exit']
  RUN_COMMANDS = ['run', 'r']
  RERUN_COMMANDS = ['rerun', '.']
  HELP_COMMANDS = ['help', 'h', '?', 'wtf']

  DUMMY_FOLDER = 'dummy/test'

  class << self
    include TestConsole::Builder
    include TestConsole::CliParser
    include TestConsole::Colors
    include TestConsole::Help
    include TestConsole::Monitor
    include TestConsole::Output
    include TestConsole::Runner

    def die
      History.write
      exit
    end

  end
end
