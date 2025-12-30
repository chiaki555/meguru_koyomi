require "date"

module Events
  module DateVariations
    class EventDateVariation
      def to_date(year)
        raise NotImplementedError
      end
    end
  end
end
