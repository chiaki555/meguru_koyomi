module SeasonalBaths
  module DateVariations
    class BathVariableDateVariation < BathDateVariation
      # ルール未設定用
      def initialize(date)
        @date = ::SeasonalBaths::ValueObjects::BathDate.new(date)
      end

      def to_date(_year)
        @date.to_date
      end
    end
  end
end
