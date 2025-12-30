module EventFoods
  class EventFoods
    include Enumerable

    def initialize(food_records)
      @foods = food_records
    end

    def each(&block)
      @foods.each(&block)
    end

    def for_modal
      if unique.empty?
      [
        {
          name: "該当なし",
          thumbnail_url: nil,
          placeholder: true
        }
      ]
      else
        unique.map(&:for_modal)
      end
    end

    private

    def unique
      @foods.uniq { |food| food.food_name.to_s }
    end
  end
end
