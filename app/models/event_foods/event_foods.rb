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
      return [] if unique.empty?

      unique.map(&:for_modal)
    end

    private

    def unique
      @foods.uniq { |food| food.food_name.to_s }
    end
  end
end
