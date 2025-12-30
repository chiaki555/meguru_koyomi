module EventTemplates
  module ValueObjects
    class EventMonth
      # 固定日用
      def initialize(value)
        @value = Integer(value.to_s.strip)
        validate!
      end

      def to_i
        @value
      end

      private

      def validate!
        raise ArgumentError, "月は1〜12で指定してください" unless (1..12).include?(@value)
      end
    end
  end
end
