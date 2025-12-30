module Events
  class Events
    include Enumerable

    def initialize(event_records)
      @events = event_records
    end

    def each(&block)
      @events.each(&block)
    end

    def calendar_events(type: "event")
      map do |event|
        {
          title: event.event_name.to_s,
          start: event.date.iso8601,
          extendedProps: {
            type: type,
            description: event.event_description.to_s,
            event_thumbnail_url: event.thumbnail_url,
            event_foods: event.foods.for_modal,
            recommended_spots: event.spots.for_modal,
            event_icon_url: event.icon_url,
            modalId: "eventModal"
          }
        }
      end
    end
  end
end
