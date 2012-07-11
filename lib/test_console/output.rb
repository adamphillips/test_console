module TestConsole
  module Output
    # Output functions
    # =================
    # Functions to format and display output

    def out(text, text_color=nil)
      if text_color
        STDOUT.puts Utility.color(text, text_color)
      else
        STDOUT.puts text
      end
    end

    def error(message, backtrace=nil)
      STDERR.puts Utility.color(message, ERROR_COLOR)
      backtrace.each {|line| STDERR.puts Utility.color(line, ERROR_COLOR)} unless backtrace.nil? || backtrace.empty?
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
