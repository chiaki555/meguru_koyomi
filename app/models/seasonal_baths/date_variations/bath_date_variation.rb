require 'date'

module SeasonalBaths
  module DateVariations
    class BathDateVariation
      def to_date(year)
        raise NotImplementedError
      end
    end
  end
end
