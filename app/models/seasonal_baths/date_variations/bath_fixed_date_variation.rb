module SeasonalBaths
  module DateVariations
    class BathFixedDateVariation < BathDateVariation
      attr_reader :month, :day

      def initialize(month, day)
        @month = ::SeasonalBaths::ValueObjects::BathMonth.new(month)
        @day   = ::SeasonalBaths::ValueObjects::BathDay.new(day)
      end

      # 実際の Date 型で返す
      def to_date(year)
        Date.new(year, @month.to_i, @day.to_i)
      end
    end
  end
end
