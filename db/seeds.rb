# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 固定データ作成
templates = [
  {
    name: "松湯",
    month: 1,
    day: 7,
    date_type: :fixed,
    description: <<~TEXT
      お正月に飾る門松の「松の葉」を使った新年を祝う縁起の良いお風呂です。
      冬でも緑を保つ松は不老長寿や生命力の象徴とされています。
    TEXT
  },
  {
    name: "大根湯",
    date_type: :variable,
    description: <<~TEXT
      大根の葉を使う保温効果のあるお風呂です。
      「白」は魔を退ける効果があるとされています。
      「身を清める」象徴としての待乳山聖天への欠かせないお供えものでもあります。
    TEXT
  },
  {
    name: "蓬湯",
    month: 3,
    day: 3,
    date_type: :fixed,
    description: <<~TEXT
      蓬（よもぎ）の葉を使うハーブ系の香りでリラックス効果のあるお風呂です。
      蓬はその強い香りや生命力から「魔除け」「厄除け」「無病息災」「子孫繁栄」の縁起物とされています。
    TEXT
  },
]

templates.each do |attrs|
  SeasonalBaths::SeasonalBathTemplate.find_or_create_by!(name: attrs[:name]) do |bath|
    bath.assign_attributes(attrs)
  end
end

# 西暦を追加可能
years = [2025, 2026, 2027]

fixed_templates = SeasonalBaths::SeasonalBathTemplate.where(date_type: :fixed)

years.each do |year|
  fixed_templates.each do |template|
    SeasonalBaths::SeasonalBath.find_or_create_by!(
      seasonal_bath_template: template,
      year: year
    )
  end
end
