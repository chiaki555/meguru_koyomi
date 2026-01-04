module SeasonalBaths
  class SeasonalBath < ApplicationRecord
    include Rails.application.routes.url_helpers
    belongs_to :seasonal_bath_template

    # 名前を取得（BathName 経由）
    def bath_name
      seasonal_bath_template.bath_name
    end

    # 概要を取得（BathDescription 経由）
    def bath_description
      seasonal_bath_template.bath_description
    end

    # Variation オブジェクト（固定日 or 変動日）
    def bath_date_variation
      if seasonal_bath_template.fixed?
        # 固定日用：テンプレの month/day カラム
        ::SeasonalBaths::DateVariations::BathFixedDateVariation.new(
          seasonal_bath_template.month,
          seasonal_bath_template.day
        )
      else
        # 変動日用：季節湯の date カラム
        ::SeasonalBaths::DateVariations::BathVariableDateVariation.new(self.date)
      end
    end

    # カレンダー表示用（固定日は year 追加）
    # def bath_date
    #   variation = bath_date_variation
    #   variation.to_date(self.year)
    # end

    def bath_date
      # すでに date があればそれを最優先
      return self[:date] if self[:date].present?

      # なければテンプレから生成
      seasonal_bath_template
        .bath_date_variation(nil)
        .to_date(year)
    end

    # サムネイル（templateより）
    def thumbnail_url
      seasonal_bath_template.thumbnail_url
    end

    # アイコン（templateより）
    def icon_url
      seasonal_bath_template&.icon_url
    end
  end
end
