module TestConsole
  module Utility
    def self.included (base)
      base.extend(ClassMethods)
    end

    # Returns an array of class components from a filename
    #
    # Common folder names are dropped from the array to avoid confusion.
    #
    # Examples:
    #
    #   class_from_filename module/controller        # ['Module', 'Controller']
    #   class_from_filename unit/module/controller   # ['Module', 'Controller']
    #   class_from_filename parent/module/controller # ['Parent', 'Module', 'Controller']
    #
    module ClassMethods
      def class_from_filename(filename)
        segs = filename.split('/')
        segs.delete ''
        segs.delete '.'
        segs.last.gsub!('.rb', '')

        # drop the test folder
        segs = segs[1..-1] while TestConsole.drop_folders.include?(segs[0])
        ret = segs.map {|seg| seg.camelize}

        return ret
      end

      # Returns boolean as to wether the specified constant is defined.
      #
      # Examples:
      #
      #   const_defined? 'String' # true
      #   const_defined? 'WierdClass' # false
      #   const_defined? ['ActiveRecord', 'Base'] # true (assuming Active Record is installed)
      #
      def const_defined?(klass)
        klass = [klass] unless klass.kind_of? Array
        klass.inject(Object) do |context, scope|
          if context.const_defined?(scope)
            context.const_get(scope)
          else
            return false
          end
        end
      end

      # Returns the specified class.
      #
      # Examples:
      #
      #   const_get 'String'                      # String
      #   const_get ['ActiveRecord', 'Base']      # ActiveRecord::Base
      #
      def const_get(klass)
        klass = [klass] unless klass.kind_of? Array
        klass.inject(Object) do |context, scope|
          context.const_get(scope)
        end
      end

      # Removes the specified class.
      #
      # Examples:
      #
      #   const_get 'String'                      # String
      #   const_get ['ActiveRecord', 'Base']      # ActiveRecord::Base
      #
      def const_remove(klass)
        klass = [klass] unless klass.kind_of? Array
        if klass.length > 1
          Utility.const_get(klass[0..-2]).send :remove_const, klass.last
        elsif klass.any?
          Object.send :remove_const, klass.last
        end
      end

    end

    extend ClassMethods

  end
end
