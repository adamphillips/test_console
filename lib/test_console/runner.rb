module TestConsole
  module Runner
    include TestConsole::Colors
    include TestConsole::Config

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

      auto_reload!
      @checked_views = false

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
                out name, success_color
              elsif result.error_count > @num_errors
                out name, error_color
              else
                out name, fail_color
              end
          end
        end
      end

      @last_run_failures = result.instance_variable_get(:@failures)
      @last_run_errors = result.instance_variable_get(:@errors)

      print_negatives @last_run_failures, fail_color
      print_negatives @last_run_errors, error_color

      print_result_summary result, Time.now - started_at

      @running = false
      @last_init_time ||= Time.now
      @last_run_time = Time.now
    end

    def abort
      (@running) ? @abort = true : die
    end
  end
end
