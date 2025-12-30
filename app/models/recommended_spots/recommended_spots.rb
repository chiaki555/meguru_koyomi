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
      @event_template_spots.uniq { |ets|
        ets.recommended_spot.spot_url.to_s.presence ||
        ets.recommended_spot.name
      }
    end
  end
end
