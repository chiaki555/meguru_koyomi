module Events
  module DateVariations
    class EventFixedDateVariation
      attr_reader :month, :day

      def initialize(month, day)
        @month = ::EventTemplates::ValueObjects::EventMonth.new(month)
        @day = ::EventTemplates::ValueObjects::EventDay.new(day)
      end

      # 実際の Date 型で返す
      def to_date(year)
        Date.new(year, @month.to_i, @day.to_i)
      end
    end
  end
end
