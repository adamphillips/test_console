class ActiveSupport::TestCase
  def self.should_set_config values
    values.each do |vkey, vval|
      should "set #{vkey} to #{vval}" do
        assert_config vkey, vval
      end
    end
  end

  def assert_config key, value, message=nil
    assert_equal value, TestConsole::Config.send(key), message
  end
end
