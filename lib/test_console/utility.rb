module TestConsole
  module Utility
    def self.included (base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      ## Returns an array of class components from a filename
      ## eg for module/controller => ['Module', 'Controller']
      def class_from_filename(filename)
        segs = filename.split('/')
        segs.delete ''
        segs.delete '.'
        segs.last.gsub!('.rb', '')

        # drop the test folder
        segs = segs[1..-1] while segs[0] == 'test'
        segs = segs[1..-1] while ['unit', 'functional' 'integration'].include?(segs[0])
        ret = segs.map {|seg| seg.camelize}

        return ret
      end

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

      def const_get(klass)
        klass = [klass] unless klass.kind_of? Array
        klass.inject(Object) do |context, scope|
          context.const_get(scope)
        end
      end

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
