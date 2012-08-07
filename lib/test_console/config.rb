module TestConsole
  def self.setup
    yield Config
  end

  # Returns an array of commands for the specfied function.
  # Valid commands are:
  #
  #   :run
  #   :rerun
  #   :quit
  #   :help
  #
  def self.commands(type)
    command = "#{type}_commands".to_sym # Deliberately not to_s-ing to avoid :
    TestConsole::Config.send(command) if TestConsole::Config.respond_to?(command)
  end

  # Configuration options for the test console.
  module Config

    class << self
      private

      # Finds the root folder of the application being tested.
      # Works by looking for a parent folder containing a gemfile.
      # If none found, it returns the current working folder.
      def find_app_root
        check_path = 'Gemfile'
        return File.expand_path('.') if File.exists?(check_path)
        check_path = "../#{check_path}"
        while File.exists?(File.dirname(check_path)) do
          return File.expand_path(File.dirname(check_path)) if File.exists?(check_path)
          check_path = "../#{check_path}"
        end
        return File.expand_path('.')
      end
    end

    # Root of the application being tested
    mattr_accessor :app_root
    @@app_root = self.send :find_app_root

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

    # These folders are dropped from class paths when determining a class from a filename
    mattr_accessor :drop_folders
    @@drop_folders = ['test', 'unit', 'functional', 'helpers', 'integration']

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

    # Failed test runs
    mattr_accessor :fail_color
    @@fail_color = :magenta

    # Successful test runs
    mattr_accessor :success_color
    @@success_color = :green

  end
end
