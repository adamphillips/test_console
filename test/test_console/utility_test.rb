require 'test_helper'

class TestConsole::UtilityTest < ActiveSupport::TestCase
  describe_method '#class_from_filename' do
    context 'when passed a filename that represents the path to a class' do
      context 'when the path matches a class' do
        setup do
          class ::TestClass
          end
        end
        should 'return an array containing the class name' do
          assert_equal ['TestClass'], TestConsole::Utility.class_from_filename('test_class')
        end
      end

      context 'when the path matches a namespaced class' do
        setup do
          module ::TestModule
            class TestClass
            end
          end
        end
        should 'return the components as an array' do
          assert_equal ['TestModule', 'TestClass'], TestConsole::Utility.class_from_filename('test_module/test_class')
        end
      end

    end
  end

  context '#const_defined?' do
    context 'when the constant is defined as a class' do
      setup do
        class ::TestClass
        end
      end
      should 'return true' do
        assert TestConsole::Utility.const_defined?('TestClass')
      end
    end

    context 'when the constant is defined as a module' do
      setup do
        module ::TestModule
        end
      end
      should 'return true' do
        assert TestConsole::Utility.const_defined?(['TestModule'])
      end
    end

    context 'when the module is nested' do
      setup do
        module ::TestModule
          class TestSubModule
          end
        end
      end
      should 'return true' do
        assert TestConsole::Utility.const_defined?(['TestModule', 'TestSubModule'])
      end
    end

    context 'when the class is nested' do
      setup do
        module ::TestModule
          class TestClass
          end
        end
      end
      should 'return true' do
        assert TestConsole::Utility.const_defined?(['TestModule', 'TestClass'])
      end
    end

    context 'when there is no matching constant' do
      should 'return false' do
        assert_false TestConsole::Utility.const_defined?(['Something', 'Nonsensical'])
      end
    end

  end
end
