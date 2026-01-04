module RecommendedSpots
  class RecommendedSpot < ApplicationRecord
    include Rails.application.routes.url_helpers

    has_many :event_template_spots, class_name: "::EventTemplateSpots::EventTemplateSpot", dependent: :destroy
    has_many :event_templates, through: :event_template_spots, class_name: "::EventTemplates::EventTemplate"

    # 代表画像
    has_one_attached :recommended_spot_thumbnail

    def spot_name
      ::RecommendedSpots::ValueObjects::SpotName.new(name)
    end

    def spot_url
      ::RecommendedSpots::ValueObjects::SpotUrl.new(url)
    end

    def thumbnail_url
      return url_for(thumbnail) if recommended_spot_thumbnail.attached?

      "https://placehold.jp/80x80.png"
    end

    def for_modal
      {
        name: name,
        url: spot_url,
        image_url: recommended_spot_thumbnail&.url,
        placeholder: false
      }
      end
  end
end
