module RecommendedSpots
  module ValueObjects
    class SpotUrl
      def initialize(value)
        @value = value.to_s.strip
      end

      def to_s
        @value
      end

      def present?
        @value.present?
      end
    end
  end
end
