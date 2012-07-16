require 'test_console/history'
require 'test_console/utility'

require 'test_console/builder'
require 'test_console/cli_parser'
require 'test_console/colors'
require 'test_console/config'
require 'test_console/help'
require 'test_console/monitor'
require 'test_console/output'
require 'test_console/runner'

require 'action_view/resolver'

module TestConsole

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
