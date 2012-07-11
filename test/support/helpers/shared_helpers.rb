class ActiveSupport::TestCase

  def assert_false value, message=nil
    assert !value, message
  end

end
