module SeasonalBaths
  module ValueObjects
    class BathDay
      def initialize(value)
        @value = Integer(value.to_s.strip)
        validate!
      end

      def to_i
        @value
      end

      private

      def validate!
        raise ArgumentError, "日は1〜31で指定してください" unless (1..31).include?(@value)
      end
    end
  end
end
