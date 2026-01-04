module SeasonalBaths
  class SeasonalBathTemplate < ApplicationRecord
    include Rails.application.routes.url_helpers

    has_many :seasonal_baths
    has_many_attached :bath_icons
    # 代表画像
    has_one_attached :bath_thumbnail
    # 追加画像用（複数）
    has_many_attached :bath_images

    enum :date_type, { fixed: 0, variable: 1 }

    # 名前を BathNameクラス でラップ
    def bath_name
      return nil if name.blank?

      ::SeasonalBaths::ValueObjects::BathName.new(name)
    end

    # 概要を BathDescriptionクラス でラップ
    def bath_description
      return nil if description.blank?

      ::SeasonalBaths::ValueObjects::BathDescription.new(description)
    end

    def bath_date_variation(date)
      DateVariations::BathDateVariation.build(
        template: self,
        date: date
      )
    end

    # サムネイル（デフォルトあり）
    def thumbnail_url
      return url_for(bath_thumbnail) if bath_thumbnail.attached?

      "https://placehold.jp/80x80.png"
    end

    # アイコン（デフォルトなし）
    def icon_url
      icon = bath_icons.first
      url_for(icon) if icon&.attached?
    end
  end
end
