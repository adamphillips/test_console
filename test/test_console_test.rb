require 'test_helper'

class TestConsoleTest < ActiveSupport::TestCase
  describe_class TestConsole do
    describe_method 'something' do
      should 'work' do
        assert true
      end
    end
  end
end
