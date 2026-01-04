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
    def event_date
      # すでに date があればそれを最優先
      return self[:date] if self[:date].present?

      # なければテンプレから生成
      event_template
        .event_date_variation(nil)
        .to_date(year)
    end

    # 行事食関連の取得
    def foods
      ::EventFoods::EventFoods.new(event_template.event_foods)
    end

    # おすすめスポット関連の取得
    def spots
      ::RecommendedSpots::RecommendedSpots.new(event_template.recommended_spots)
    end

    # サムネイル（templateより）
    def thumbnail_url
      event_template.thumbnail_url
    end

    # アイコン（templateより）
    def icon_url
      event_template&.icon_url
    end
  end
end
