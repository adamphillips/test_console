require 'hirb'

module TestConsole
  module Output
    include TestConsole::Colors

    # Output functions
    # =================
    # Functions to format and display output

    def out(text, text_color=nil)
      extend Hirb::Console
      text = text.to_a if text.kind_of? ActiveRecord::Base

      if text.kind_of? Array
        STDOUT.puts start_color text_color if text_color
        table text
        STDOUT.puts reset_color if text_color
      else
        text = color(text, text_color) if text_color

        STDOUT.puts text
      end
    end

    def error(message, backtrace=nil)
      STDERR.puts color(message, ERROR_COLOR)
      backtrace.each {|line| line_color = (line[0..1] == '/') ? BACKTRACE_LOCAL_COLOR : BACKTRACE_GEM_COLOR; STDERR.puts color(line, line_color)} unless backtrace.nil? || backtrace.empty?
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
        final_color = SUCCESS_COLOR
      elsif result.error_count > 0
        final_color = ERROR_COLOR
      else
        final_color = FAIL_COLOR
      end

      out "\nTests: #{result.run_count}, Assertions: #{result.assertion_count}, Fails:  #{result.failure_count}, Errors: #{result.error_count}, Time taken #{sprintf('%.2f', time_taken)}s", final_color
    end
  end
end
