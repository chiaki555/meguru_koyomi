require "date"

module SeasonalBaths
  module DateVariations
    class BathDateVariation
      def self.build(template:, date:)
        return BathVariableDateVariation.new(date) if date.present?
        BathFixedDateVariation.new(template.month, template.day)
      end
    end
  end
end
