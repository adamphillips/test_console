require 'test_helper'

class TestConsole::BuilderTest < ActiveSupport::TestCase
  describe TestConsole do
    describe '#filter_tests' do
      context 'when passed a test suite' do
        setup do
          class TestCase1 < ActiveSupport::TestCase
            def a_test; end
            def Second_Test; end
            def something_different; end
          end

          @test1 = TestCase1.new 'a_test'
          @test2 = TestCase1.new 'Second_Test'
          @test3 = TestCase1.new 'something_different'

          @test_suite = Test::Unit::TestSuite.new 'A sample suite'

          @test_suite.tests << @test1
          @test_suite.tests << @test2
          @test_suite.tests << @test3
        end

        teardown do
          TestConsole::Utility.const_remove ['TestConsole', 'BuilderTest', 'TestCase1']
        end

        context 'and a string' do
          should 'return a suite containing the matching tests' do
            @filtered = TestConsole.filter_tests @test_suite, 'test'
            assert_equal 1, @filtered.tests.length
            assert @filtered.tests.include?(@test1)
          end
        end

        context 'and a regex' do
          should 'return a suite containing the matching tests' do
            @filtered = TestConsole.filter_tests @test_suite, /_test/i
            assert_equal 2, @filtered.tests.length
            assert @filtered.tests.include?(@test1)
            assert @filtered.tests.include?(@test2)
          end
        end
      end
    end
  end
end
