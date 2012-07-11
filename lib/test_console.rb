require 'test_console/history'
require 'test_console/output'
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
    include TestConsole::Output

    # Checks that the specified path is valid
    # If so it creates a test suite from the path and runs it
    def run path, filter=nil
      begin
        unless path && !path.empty?
          raise 'No path specified'
        end

        unless File.exists? path
          raise "Path #{path} doesn't exist"
        end

        auto_reload!
        @checked_views = false

        if File.directory? path
          suite = make_suite_from_folder(path, filter)
        else
          suite = make_suite_from_file(path, filter)
        end

        suite = filter_tests(suite, filter) if filter

        @last_run_path = path
        @last_run_filter = filter

        run_suite suite
      rescue Exception => e
        error e.message, e.backtrace
      end
    end

    # Reruns previous failures or errors
    def rerun type=nil
      return false unless @last_run_path

      if File.directory? @last_run_path
        suite = make_suite_from_folder(@last_run_path, @last_run_filter)
      else
        suite = make_suite_from_file(@last_run_path, @last_run_filter)
      end

      suite = filter_tests(suite, @last_run_filter) if @last_run_filter

      to_rerun = []

      to_rerun += @last_run_failures unless type == :errors
      to_rerun += @last_run_errors unless type == :failures

      out 'All tests passed last time.  Nothing to rerun', :green and return true if to_rerun.empty?

      to_rerun = to_rerun.collect {|t| t.test_name}

      failed_suite = Test::Unit::TestSuite.new 'Previous test failures'
      suite.tests.each {|t| failed_suite.tests << t if to_rerun.include?(t.name)}

      run_suite failed_suite
    end

    # Runs a defined suite of tests
    def run_suite(suite)
      @abort = false
      @running = true

      return false if stop_folders_changed?

      result = Test::Unit::TestResult.new
      started_at = Time.now

      suite.tests.each do |test|
        break if @abort
        test.run result do |type, name|
          case type
            when Test::Unit::TestCase::STARTED
              @num_failures = result.failure_count
              @num_errors = result.error_count
            when Test::Unit::TestCase::FINISHED
              if result.failure_count == @num_failures && result.error_count == @num_errors
                out name, SUCCESS_COLOR
              elsif result.error_count > @num_errors
                out name, ERROR_COLOR
              else
                out name, FAIL_COLOR
              end
          end
        end
      end

      @last_run_failures = result.instance_variable_get(:@failures)
      @last_run_errors = result.instance_variable_get(:@errors)

      print_negatives @last_run_failures, FAIL_COLOR
      print_negatives @last_run_errors, ERROR_COLOR

      print_result_summary result, Time.now - started_at

      @running = false
      @last_init_time ||= Time.now
      @last_run_time = Time.now
    end

    def abort
      (@running) ? @abort = true : die
    end

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

    # Suite generation functions
    # ==========================
    # Functions to generate and refine suites of tests

    def filter_tests(suite, filter)
      STDOUT.puts color("Filtering with #{filter.inspect}", :yellow)
      new_suite = Test::Unit::TestSuite.new(suite.name)
      suite.tests.each{|t| new_suite.tests << t if t.name.match filter}
      new_suite
    end

    # Creates a test suite based on a path to a test file
    def make_suite_from_file(test_filename, filter=nil)
      test_file = File.join(test_filename)
      raise "Can't find #{test_file}" and return unless File.exists?(test_file)

      klass = Utility.class_from_filename(test_file)

      Utility.const_remove(klass) if Utility.const_defined?(klass)
      load test_file

      if Utility.const_defined?(klass)
        return suite = Utility.const_get(klass).suite
      else
        raise "WARNING: #{test_filename} does not define #{klass.join('/')}"
      end
    end

    # Creates a test suite based on a path to a folder of tests
    def make_suite_from_folder(path, filter=nil)
      suite = Test::Unit::TestSuite.new(path)

      Dir.glob(File.join("**", "*_test.rb")).each do |fname|
        if fname[0..DUMMY_FOLDER.length] != "#{DUMMY_FOLDER}/"
          klass = Utility.class_from_filename(fname)

          Utility.const_remove(klass) if Utility.const_defined?(klass)

          load fname

          if Utility.const_defined?(klass)
            Utility.const_get(klass).suite.tests.each {|t| suite.tests << t}
          else
            raise "WARNING: #{fname} does not define #{klass.join('/')}"
          end
        end
      end
      return suite
    end

    # Monitoring functions
    # ====================
    # These are functions that check for changes whilst the console is open
    # and reload the files if possible

    # Checks for changes to watched folders and reloads the files if necessary
    def auto_reload!
      # If nil, this means that this is the first run and nothing has changed since initialising the rails env
      @last_reload_time = Time.now and return if @last_reload_time.nil?

      WATCH_PATHS.each do |p|
        watch_folder = File.join(Rails.root.to_s, p)
        Dir.glob(File.join(watch_folder, '**', '*.*rb')).each do |f|
          if File.mtime(f) > @last_reload_time
            rel_path = f[watch_folder.length+1..-1]
            out "Reloading #{rel_path}", :cyan
            klass = Utility.class_from_filename(rel_path)
            const_remove(klass) if const_defined?(klass)
            load f
          end
        end
      end

      @last_reload_time = Time.now
    end

    # This monitors the stop folders for changes since the console was initialised
    def stop_folders_changed?
      # If nil, this means that this is the first run and nothing has changed since initialising the rails env
      return false if @last_init_time.nil?

      STOP_FOLDERS.each do |p|
        watch_folder = File.join(Rails.root.to_s, p)
        Dir.glob(File.join(watch_folder, '**', '*.{rb,yml}')).each do |f|
          if File.mtime(f) > @last_init_time
            error "#{f} has been changed.\nYou will need to restart the console to reload the environment"
            return true
          end
        end
      end

      return false

    end

    # Checks wether views have changed
    def views_changed?
      # If nil, this means that this is the first run and nothing has changed since initialising the rails env
      @last_run_time = Time.now and return false if @last_run_time.nil?
      return false if @checked_views

      VIEW_FOLDERS.each do |vf|
        watch_folder = File.join(Rails.root.to_s, vf)
        Dir.glob(File.join(watch_folder, '**', '*')).each do |f|
          if File.mtime(f) > @last_run_time
            @checked_views = true
            return true
          end
        end
      end

      @checked_views = true

      return false
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

