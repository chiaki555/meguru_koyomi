module SeasonalBaths
  class SeasonalBaths
    include Enumerable

    def initialize(seasonal_bath_records)
      @baths = seasonal_bath_records
    end

    # Enumerable用
    def each(&block)
      @baths.each(&block)
    end

    # カレンダー表示用に整形：季節湯
    def calendar_baths(type: "bath")
      map do |bath|
        {
          title: bath.bath_name.to_s,
          start: bath.bath_date.iso8601,
          extendedProps: {
            type: "bath",
            description: bath.bath_description.to_s,
            thumbnail_url: bath.thumbnail_url,
            icon_url: bath.icon_url,
            modalId: "seasonalBathModal"
          }
        }
      end
    end
  end
end
