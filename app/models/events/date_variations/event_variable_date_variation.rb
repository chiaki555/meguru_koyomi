module Events
  module DateVariations
    class EventVariableDateVariation
      # 変動日ルール未設定用
      def initialize(date)
        @date = ::Events::ValueObjects::EventDate.new(date)
      end

      def to_date(_year)
        @date.to_date
      end
    end
  end
end
