require 'test_helper'

class TestConsole::CliParserTest < ActiveSupport::TestCase
  describe_class TestConsole::CliParser do
    describe_method '#command' do
      context 'when passed a string' do
        should 'take the first segment of the string and return it' do
          assert_equal 'something', TestConsole::CliParser.command('something')
          assert_equal 'something', TestConsole::CliParser.command('something else')
          assert_equal 'something', TestConsole::CliParser.command('something else /with_ex/')
        end
      end
    end

    describe_method '#file' do
      context 'when passed a string' do
        should 'take the second segment of the string and return it' do
          assert_equal nil, TestConsole::CliParser.file('something')
          assert_equal 'else', TestConsole::CliParser.file('something else')
          assert_equal 'else', TestConsole::CliParser.file('something else /with_ex/')
        end
      end
    end

    describe_method '#filter' do
      context 'when passed a string' do
        should 'take the third segment of the string and return it as a regex' do
          assert_equal nil, TestConsole::CliParser.filter('something')
          assert_equal nil, TestConsole::CliParser.filter('something else')
          assert_equal /with ex/, TestConsole::CliParser.filter('something else with ex')
          assert_equal /with_ex/, TestConsole::CliParser.filter('something else /with_ex/')
        end
      end
    end
  end
end
