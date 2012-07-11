class ActiveSupport::TestCase

  def self.described_class
    class_name = self.to_s[0..-5]
    class_name.constantize
  end

  class << self
    def describe_class class_name, &block
      context "#{class_name.to_s}" do
        merge_block &block
      end
    end

    def describe_method method, &block
      context method do
        merge_block &block
      end
    end

    def subject
    end
  end

end
