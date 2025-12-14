module SeasonalBaths
  module ValueObjects
    class BathDate
      # 変動日用
      def initialize(date)
        @date = ::Date.parse(date.to_s)
      end

      def to_date
        @date
      end
    end
  end
end
