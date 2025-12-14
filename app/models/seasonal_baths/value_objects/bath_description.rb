module SeasonalBaths
  module ValueObjects
    class BathDescription
      def initialize(value)
        @value = value.to_s.strip
        validate!
      end

      def to_s
        @value
      end

      private

      def validate!
        raise ArgumentError, "概要は 300 文字以内にしてください" if @value.length > 300
      end
    end
  end
end
