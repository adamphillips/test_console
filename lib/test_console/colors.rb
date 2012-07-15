module TestConsole
  module Colors

    # Standard terminal color codes
    COLORS = {
      :reset => '0',
      :bold => '1',
      :red => '31',
      :green => '32',
      :yellow => '33',
      :blue => '34',
      :magenta => '35',
      :cyan => '36',
      :white => '37'
    }

    ERROR_COLOR = :magenta
    FAIL_COLOR = :red
    SUCCESS_COLOR = :green

    def color(text, color)
      if COLORS[color]
        "#{start_color color}#{text}#{reset_color}"
      end
    end

    def reset_color
      "\e[#{COLORS[:reset]}m"
    end

    def start_color color
      "\e[#{COLORS[color]}m"
    end
  end
end
