class ActiveSupport::TestCase

  def assert_defined const, message=nil
    message ||= "#{const} is undefined"

    begin
      const.constantize
      result = true
    rescue
      result = false
    end

    assert result, message
  end

  def assert_false value, message=''
    assert !value, message
  end

  def assert_undefined const, message=nil
    message ||= "#{const} is defined"

    begin
      const.constantize
      result = false
    rescue
      result = true
    end

    assert result, message
  end

end
