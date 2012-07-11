require 'test_console/history'

require 'test_console/builder'
require 'test_console/monitor'
require 'test_console/output'
require 'test_console/runner'

require 'test_console/utility'

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

  COLORS = {
    :reset => '0',
    :bold => '1',
    :red => '31',
    :green => '32',
    :yellow => '33',
    :blue => '34',
    :magenta => '35',
    :cyan => '36',
    :white => '37'
  }

  ERROR_COLOR = :magenta
  FAIL_COLOR = :red
  SUCCESS_COLOR = :green

  class << self
    include TestConsole::Builder
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

    # Utility functions
    # =================
    # Additional functions to help with general tasks

    # Help text
    # =========

    def help
    "
    Test console help
    =================
    Run Commands : #{RUN_COMMANDS.join(', ')}

    To run a test, type 'run' followed by the path to the test
    You can also append a string or regex to filter by

    Examples:
      run functional/mgm
      run functional/application_controller_test.rb
      run functional/application_controller_test.rb 'PartOfTestName'
      run functional/application_controller_test.rb /PartOfTestName/i

    Rerun Commands : #{RERUN_COMMANDS.join(', ')}

    Reruns only the tests that failed or errored in the previous run

    Quit Commands : #{QUIT_COMMANDS.join(', ')}

    Exits the console
    "
    end

  end
end

# This sets ActionView to use our custom test when checking whether to cache view templates
module ActionView
  class Resolver
    def caching?
      @caching = TestConsole.views_changed?
    end
  end
end

