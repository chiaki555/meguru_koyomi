module RecommendedSpots
  class RecommendedSpots
    include Enumerable

    def initialize(spot_records)
      @spots = spot_records
    end

    def each(&block)
      @spots.each(&block)
    end

    def for_modal
      return [] if unique.empty?

      unique.map(&:for_modal)
    end

    private

    def unique
      @spots.uniq { |spot|
        spot.spot_url.to_s.presence ||
        spot.name
      }
    end
  end
end
