module TestConsole
  module Builder
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

  end
end
