module EventFoods
  class EventFood < ApplicationRecord
    include Rails.application.routes.url_helpers

    has_many :event_template_foods, class_name: "::EventTemplateFoods::EventTemplateFood", dependent: :destroy
    has_many :event_templates, through: :event_template_foods, class_name: "::EventTemplates::EventTemplate"

    # 代表画像
    has_one_attached :event_food_thumbnail
    # 追加画像用（複数）
    has_many_attached :event_food_images

    def food_name
      ::EventFoods::ValueObjects::FoodName.new(name)
    end

    def for_modal
      {
        name: food_name.to_s,
        thumbnail_url: thumbnail_url
      }
    end

    def thumbnail_url
      return url_for(thumbnail) if event_food_thumbnail.attached?

      nil
    end
  end
end
