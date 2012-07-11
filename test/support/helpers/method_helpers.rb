class ActiveSupport::TestCase

  def self.described_class
    class_name = self.to_s[0..-5]
    class_name.constantize
  end

  class << self
    def describe_method method, &block
      context method do
        merge_block &block
      end
    end

    def subject
    end
  end

  def assert_false value, message=nil
    assert !value, message
  end

end
