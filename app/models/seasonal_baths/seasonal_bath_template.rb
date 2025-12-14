module SeasonalBaths
  class SeasonalBathTemplate < ApplicationRecord
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
  end
end
