class HomesController < ApplicationController
  def index
    # DBからSeasonalBathを取得（テンプレート込み）
    seasonal_bath_records = SeasonalBaths::SeasonalBath.includes(:seasonal_bath_template)

    # ファーストクラスコレクションを使う
    seasonal_baths = SeasonalBaths::SeasonalBaths.new(seasonal_bath_records)

    # カレンダー用データを取得
    calendar_baths = seasonal_baths.calendar_baths

    # 後で行事を追加してまとめるため
    @calendar_items = calendar_baths

    respond_to do |format|
      format.html
      format.json { render json: @calendar_items }
    end
  end
end