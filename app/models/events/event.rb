module Events
  class Event < ApplicationRecord
    include Rails.application.routes.url_helpers

    belongs_to :event_template, class_name: "::EventTemplates::EventTemplate"

    # 名前の取得
    def event_name
      event_template.event_name
    end

    # 概要の取得
    def event_description
      event_template.event_description
    end

    # カレンダー表示用（固定日は year 追加）
    def date
      event_template
        .event_date_variation(self[:date])
        .to_date(year)
    end

    # 行事食関連の取得
    def foods
      ::EventFoods::EventFoods.new(event_foods)
    end

    # おすすめスポット関連の取得
    def spots
      ::RecommendedSpots::RecommendedSpots.new(recommended_spots)
    end

    # サムネイル（デフォルトあり）
    def thumbnail_url
      thumbnail = event_template&.event_thumbnail

      return url_for(thumbnail) if thumbnail&.attached?
      "https://placehold.jp/80x80.png"
    end

    # アイコン（デフォルトなし）
    def icon_url
      first_icon = event_template&.event_icons&.first

      return url_for(first_icon) if first_icon&.attached?

      nil
    end
  end
end
