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
          start: event.event_date.iso8601,
          extendedProps: {
            type: type,
            event_template_id: event.event_template_id,
            description: event.event_description.to_s,
            thumbnail_url: event.thumbnail_url,
            foods: event.foods.for_modal,
            spots: event.spots.for_modal,
            icon_url: event.icon_url,
            modalId: "eventModal"
          }
        }
      end
    end
  end
end
