module TestConsole
  module Utility
    class << self
      def class_from_filename(filename)

        segs = filename.split('/')
        segs.delete ''
        segs.last.gsub!('.rb', '')

        # drop the test folder
        segs = segs[1..-1] while segs[0] == 'test'

        ret = segs.map {|seg| seg.camelize}

        return ret
      end

      def const_defined?(klass)
        klass.inject(Object) do |context, scope|
          if context.const_defined?(scope)
            context.const_get(scope)
          else
            return false
          end
        end
      end

      def const_get(klass)
        klass.inject(Object) do |context, scope|
          context.const_get(scope)
        end
      end

    end
  end
end
