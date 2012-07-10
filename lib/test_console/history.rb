module TestConsole
  module History
    LIMIT = 1000
    LOCATION = "#{ENV['HOME']}/.tc_history"

    class << self
      def add line
        Readline::HISTORY.push line
      end

      def read
        if File.exists?(LOCATION)
          File.open(LOCATION) do |file|
            history = Marshal.load(file)
            history.each {|h| Readline::HISTORY.push h} if history
          end
        end
      end

      def write
        history = Readline::HISTORY.to_a
        history = (history.reverse[0, LIMIT]).reverse

        File.open(LOCATION, 'w+') do |file|
          Marshal.dump(history, file)
        end
      end
    end
  end
end

