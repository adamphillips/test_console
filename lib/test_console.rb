require 'test_console/history'
require 'test_console/utility'

require 'test_console/builder'
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
    include TestConsole::Colors
    include TestConsole::Help
    include TestConsole::Monitor
    include TestConsole::Output
    include TestConsole::Runner

    def die
      History.write
      exit
    end

    # Parsing functions
    # =================
    # Functions to parse and normalise user input

    # parses the command section of a line of user input
    def command(line)
      line.split(' ')[0]
    end

    # parses the file component of a line of user input
    def file(line)
      begin
        line.split(' ')[1] if line.include? ' '
      rescue
      end
    end

    # parses the filter component of a line of input
    def filter(line)
      begin
        filter_str = line.split(' ')[2..-1].join(' ')
        filter = eval filter_str
        filter = "/#{filter_str}/" unless filter.kind_of?(Regexp) || filter_str.nil? || filter_str.empty?
        return filter
      rescue
        /#{filter_str}/ unless filter_str.nil? || filter_str.empty?
      end
    end

  end
end
