require "date"
require "holiday_jp"

# 共通メソッド
def create_bath(template, date: nil, year: nil)
  ::SeasonalBaths::SeasonalBath.find_or_create_by!(
    seasonal_bath_template: template,
    date: date,
    year: year
  )
end

# 西暦を追加可能
years = [ 2025, 2026, 2027 ]

# 季節湯：固定
bath_fixed_templates = ::SeasonalBaths::SeasonalBathTemplate.where(date_type: :fixed)
years.each do |year|
  bath_fixed_templates.each do |template|
    ::SeasonalBaths::SeasonalBath.find_or_create_by!(
      seasonal_bath_template: template,
      year: year
    )
  end
end

# ----- 手動（計算式未設定）-----
# 日付の設定
manual_dates = {
  # 節分
  "大根湯" => {
    2025 => Date.new(2025, 2, 2),
    2026 => Date.new(2026, 2, 3),
    2027 => Date.new(2027, 2, 3)
  },
  # 土用の丑の日
  "桃湯" => {
    2025 => Date.new(2025, 7, 19),
    2026 => Date.new(2026, 7, 26),
    2027 => Date.new(2027, 7, 21)
  },
  # 立秋
  "薄荷湯" => {
    2025 => Date.new(2025, 8, 7),
    2026 => Date.new(2026, 8, 7),
    2027 => Date.new(2027, 8, 8)
  },
  # 寒露
  "生姜湯" => {
    2025 => Date.new(2025, 10, 8),
    2026 => Date.new(2026, 10, 8),
    2027 => Date.new(2027, 10, 8)
  },
  # 立冬
  "蜜柑湯" => {
    2025 => Date.new(2025, 11, 7),
    2026 => Date.new(2026, 11, 7),
    2027 => Date.new(2027, 11, 8)
  },
  # 冬至
  "柚子湯" => {
    2025 => Date.new(2025, 12, 22),
    2026 => Date.new(2026, 12, 22),
    2027 => Date.new(2027, 12, 22)
  }
}

manual_dates.each do |name, dates|
  template = ::SeasonalBaths::SeasonalBathTemplate.find_by(name: name)
  next unless template

  dates.each do |year, date|
    create_bath(template, date: date, year: date.year)
  end
end
