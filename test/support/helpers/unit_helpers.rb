class ActiveSupport::TestCase

  def self.described_class
    class_name = self.to_s[0..-5]
    class_name.constantize
  end

  class << self
    def describe identifier, &block
      return describe_class(identifier, &block) if identifier.kind_of? Class
      return describe_module(identifier, &block) if identifier.kind_of? Module
      return describe_method(identifier, &block) if identifier.kind_of?(String) && ['#', '.'].include?(identifier[0, 1])
      context identifier do
        merge_block &block
      end
    end

    def describe_class class_name, &block
      context "#{TestConsole.color(class_name.to_s, :blue)}" do
        merge_block &block
      end
    end

    def describe_method method, &block
      context TestConsole.color("#{method}\n", :cyan) do
        merge_block &block
      end
    end

    def describe_module module_name, &block
      context "#{TestConsole.color module_name.to_s, :yellow}" do
        merge_block &block
      end
    end

    def subject
    end
  end

end
