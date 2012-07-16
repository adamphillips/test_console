module TestConsole
  module CliParser
    def self.included(base)
      base.send(:include, Parsers)
    end

    module Parsers
      # Parsing functions
      # =================
      # Functions to parse and normalise user input

      # parses the command section of a line of user input
      def command(line)
        line.split(' ')[0]
      end

      # parses the file component of a line of user input
      def file(line)
        begin
          line.split(' ')[1]
        rescue
        end
      end

      # parses the filter component of a line of input
      def filter(line)
        begin
          filter_str = line.split(' ')[2..-1].join(' ')
          filter = eval filter_str
          filter = "/#{filter_str}/" unless filter.kind_of?(Regexp) || filter_str.nil? || filter_str.empty?
          return filter
        rescue
          /#{filter_str}/ unless filter_str.nil? || filter_str.empty?
        end
      end
    end

    extend Parsers
  end
end
