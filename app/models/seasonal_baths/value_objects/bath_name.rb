module SeasonalBaths
  module ValueObjects
    class BathName
      def initialize(value)
        @value = value.to_s.strip
        validate!
      end

      def to_s
        @value
      end

      private

      def validate!
        raise ArgumentError, "名前は必ず『○○湯』にしてください" unless ends_with_yu?
      end

      def ends_with_yu?
        @value.end_with?("湯")
      end
    end
  end
end
