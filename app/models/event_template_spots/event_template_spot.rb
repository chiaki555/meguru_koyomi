module EventTemplateSpots
  class EventTemplateSpot < ApplicationRecord
    include Rails.application.routes.url_helpers

    belongs_to :event_template, class_name: "::EventTemplates::EventTemplate"
    belongs_to :recommended_spot, class_name: "::RecommendedSpots::RecommendedSpot"

    # 行事 × スポット専用画像
    has_one_attached :spot_image

    def image_url
      return url_for(spot_image) if spot_image.attached?

      recommended_spot.thumbnail_url
    end

    def for_modal
      {
        name: recommended_spot.name,
        image_url: image_url
      }
    end
  end
end
