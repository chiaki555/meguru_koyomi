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
      if unique.empty?
      [
        {
          name: "該当なし",
          url: nil,
          image_url: nil,
          placeholder: true
        }
      ]
      else
        unique.map(&:for_modal)
      end
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
