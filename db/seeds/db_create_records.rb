require_relative "helpers"
require_relative "bath_templates"
require_relative "event_templates"

# ----- レコード作成 -----
# 季節湯
BATH_TEMPLATES.each do |attrs|
  ::SeasonalBaths::SeasonalBathTemplate.find_or_create_by!(name: attrs[:name]) do |b|
    b.assign_attributes(attrs)
  end
end

# 行事
EVENT_TEMPLATES.each do |attrs|
  ::EventTemplates::EventTemplate.find_or_create_by!(name: attrs[:name]) do |e|
    e.assign_attributes(attrs)
  end
end

# ----- 紐づけ -----
# 行事食
attach_food_to_events("御節", [ "元日" ])
attach_food_to_events("御屠蘇", [ "元日" ])

attach_food_to_events("七草粥", [ "人日の節句" ])

attach_food_to_events("御汁粉", [ "鏡開き" ])
attach_food_to_events("御雑煮", [ "鏡開き" ])

attach_food_to_events("恵方巻", [ "節分" ])
attach_food_to_events("稲荷寿司", [ "節分", "初午" ])
attach_food_to_events("鰯", [ "節分" ])
attach_food_to_events("初午団子", [ "初午" ])

attach_food_to_events("ちらし寿司", [ "人日の節句" ])
attach_food_to_events("蛤の御吸い物", [ "人日の節句" ])
attach_food_to_events("菱餅", [ "人日の節句" ])
attach_food_to_events("雛あられ", [ "人日の節句" ])
attach_food_to_events("白酒", [ "人日の節句" ])

attach_food_to_events("牡丹餅", [ "春彼岸" ])
attach_food_to_events("入り団子", [ "春彼岸", "秋彼岸" ])
attach_food_to_events("赤飯", [ "春彼岸", "秋彼岸" ])
attach_food_to_events("明け団子", [ "春彼岸", "秋彼岸" ])

attach_food_to_events("甘茶", [ "灌仏会" ])

attach_food_to_events("柏餅", [ "端午の節句" ])
attach_food_to_events("粽", [ "端午の節句" ])
attach_food_to_events("草餅", [ "端午の節句" ])

attach_food_to_events("水無月", [ "夏越の大祓" ])
attach_food_to_events("夏越御飯", [ "夏越の大祓" ])
attach_food_to_events("夏越豆腐", [ "夏越の大祓" ])

attach_food_to_events("索餅", [ "七夕の節句" ])
attach_food_to_events("素麺", [ "七夕の節句", "盂蘭盆会" ])

attach_food_to_events("迎え団子", [ "盂蘭盆会" ])
attach_food_to_events("送り団子", [ "盂蘭盆会" ])
attach_food_to_events("精進揚げ", [ "盂蘭盆会" ])

attach_food_to_events("菊酒", [ "重陽の節句" ])
attach_food_to_events("栗御飯", [ "重陽の節句" ])
attach_food_to_events("秋茄子", [ "重陽の節句" ])

attach_food_to_events("御萩", [ "秋彼岸" ])

attach_food_to_events("月見団子", [ "十五夜", "十三夜" ])
attach_food_to_events("月見酒", [ "十五夜", "十三夜" ])
attach_food_to_events("薩摩芋御飯", [ "十五夜" ])
attach_food_to_events("月餅", [ "十五夜", "十三夜" ])

attach_food_to_events("栗御飯", [ "十三夜" ])
attach_food_to_events("豆御飯", [ "十三夜" ])

attach_food_to_events("年越し蕎麦", [ "年越しの大祓" ])

# おすすめのスポット
attach_spot_to_events("氏神様", [ "元日", "夏越の大祓", "年越しの大祓" ])
attach_spot_to_events("稲荷神社", [ "初午" ])
attach_spot_to_events("仏教寺院", [ "灌仏会" ])
