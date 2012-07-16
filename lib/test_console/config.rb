module TestConsole
  def self.setup
    yield Config
  end

  def self.commands(type)
    command = "#{type}_commands".to_sym # Deliberately not to_s-ing to avoid :
    TestConsole::Config.send(command) if TestConsole::Config.respond_to?(command)
  end

  module Config

    # Folders to watch
    mattr_accessor :watch_paths
    @@watch_paths = ['test/support', 'lib', 'app/models', 'app/controllers', 'app/helpers', 'app/presenters']

    # Folders containing views
    mattr_accessor :view_folders
    @@view_folders = ['app/views']

    # These are folders that mean the test console need to be reloaded if any files in them are modified.
    # The file types checked are .rb and .yml
    mattr_accessor :stop_folders
    @@stop_folders = ['test/fixtures', 'config/environments']


    # CLI Commands
    #
    # Can be typed on the console command line

    # Cli commands to run tests
    mattr_accessor :run_commands
    @@run_commands = ['run', 'r']

    # Cli commands to quit the console
    mattr_accessor :quit_commands
    @@quit_commands = ['quit', 'q', 'exit']

    # Cli commands to rerun tests
    mattr_accessor :rerun_commands
    @@rerun_commands = ['rerun', '.']

    # Cli commands to display the help page
    mattr_accessor :help_commands
    @@help_commands = ['help', 'h', '?', 'wtf']


    # Dummy application path for when testing plugins or engines
    mattr_accessor :dummy_folder
    @@dummy_folder = 'dummy/test'

    # Colors
    #
    # Colors used for different types of output

    # Errors
    mattr_accessor :error_color
    @@error_color = :red

    # Backtrace
    mattr_accessor :backtrace_local_color, :backtrace_gem_color
    @@backtrace_local_color = @@error_color
    @@backtrace_gem_color = :magenta

    # Fail
    mattr_accessor :fail_color
    @@fail_color = :magenta

    # Success
    mattr_accessor :success_color
    @@success_color = :green

  end
end
