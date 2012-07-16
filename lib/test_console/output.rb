require 'hirb'

module TestConsole
  module Output
    include TestConsole::Colors
    include TestConsole::Config

    # Output functions
    # =================
    # Functions to format and display output

    def out(text, text_color=nil, *opts)
      extend Hirb::Console
      text = text.to_a if text.kind_of? ActiveRecord::Base

      if text.kind_of? Array
        STDOUT.puts start_color text_color if text_color
        table text, *opts
        STDOUT.puts reset_color if text_color
      else
        text = color(text, text_color) if text_color

        STDOUT.puts text
      end
    end

    def error(message, backtrace=nil)
      STDERR.puts color(message, error_color)
      backtrace.each {|line| line_color = (line[0..1] == '/') ? backtrace_local_color : backtrace_gem_color; STDERR.puts color(line, line_color)} unless backtrace.nil? || backtrace.empty?
    end

    def print_negatives(items, color)
      if items.kind_of? Array
        items.each do |item|
          out "\n#{item.long_display}", color
        end
      end
    end

    def print_result_summary(result, time_taken=0)
      if result.failure_count == 0 && result.error_count == 0
        final_color = success_color
      elsif result.error_count > 0
        final_color = error_color
      else
        final_color = fail_color
      end

      out "\nTests: #{result.run_count}, Assertions: #{result.assertion_count}, Fails:  #{result.failure_count}, Errors: #{result.error_count}, Time taken #{sprintf('%.2f', time_taken)}s", final_color
    end
  end
end
