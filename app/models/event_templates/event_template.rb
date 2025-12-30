module EventTemplates
  class EventTemplate < ApplicationRecord
    has_many :events, dependent: :destroy, class_name: "::Events::Event"

    # 中間テーブル
    has_many :event_template_spots, class_name: "::EventTemplateSpots::EventTemplateSpot", dependent: :destroy
    has_many :event_template_foods, class_name: "::EventTemplateFoods::EventTemplateFood", dependent: :destroy

    # through
    has_many :recommended_spots, through: :event_template_spots, class_name: "::RecommendedSpots::RecommendedSpot"
    has_many :event_foods, through: :event_template_foods, class_name: "::EventFoods::EventFood"

    has_many_attached :event_icons
    # 代表画像
    has_one_attached :event_thumbnail
    # 追加画像用（複数）
    has_many_attached :event_images

    enum :date_type, { fixed: 0, variable: 1 }
    enum :source_type, { auto: 0, manual: 1 }
    enum :area_type, { national: 0, regional: 1 }

    def event_name
      ::EventTemplates::ValueObjects::EventName.new(name)
    end

    def event_description
      ::EventTemplates::ValueObjects::EventDescription.new(description)
    end

    def event_month
      ::EventTemplates::ValueObjects::EventMonth.new(month)
    end

    def event_day
      ::EventTemplates::ValueObjects::EventDay.new(day)
    end

    # 固定日か変動日か
    def event_date_variation(variable_date)
      fixed_variation || variable_variation(variable_date)
    end

    private

    # 固定日
    def fixed_variation
      ::Events::DateVariations::EventFixedDateVariation.new(month, day) if fixed?
    end

    # 変動日
    def variable_variation(variable_date)
      ::Events::DateVariations::EventVariableDateVariation.new(variable_date)
    end
  end
end
