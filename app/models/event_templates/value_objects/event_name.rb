module EventTemplates
  module ValueObjects
    class EventName
      def initialize(value)
        @value = value.to_s.strip
      end

      def to_s
        @value
      end
    end
  end
end
