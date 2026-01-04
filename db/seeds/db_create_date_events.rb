require "date"
require "holiday_jp"

# 共通メソッド
def create_event(template, date: nil, year: nil)
  ::Events::Event.find_or_create_by!(
    event_template: template,
    date: date,
    year: year
  )
end

# 西暦を追加可能
years = [ 2025, 2026, 2027 ]

# 行事：固定＆手動
holiday_names = years.flat_map do |year|
  HolidayJp.between(
    Date.new(year, 1, 1),
    Date.new(year, 12, 31)
  ).map(&:name)
end.uniq

event_fixed_templates =
  ::EventTemplates::EventTemplate
    .where(date_type: :fixed, source_type: :manual)
    .where.not(name: holiday_names)

years.each do |year|
  event_fixed_templates.each do |template|
    date = Date.new(year, template.month, template.day)

    ::Events::Event.find_or_create_by!(
      event_template: template,
      date: date
    )
  end
end

# 盂蘭盆会用
obon = ::EventTemplates::EventTemplate.find_by(name: "盂蘭盆会")
years.each do |year|
  (13..16).each do |day|
    date = Date.new(year, 8, day)
    create_event(obon, date: date, year: date.year)
  end
end

# ----- 手動（計算式未設定）-----
# 日付の設定
manual_dates = {
  "節分" => {
    2025 => Date.new(2025, 2, 2),
    2026 => Date.new(2026, 2, 3),
    2027 => Date.new(2027, 2, 3)
  },
  "初午" => {
    2025 => Date.new(2025, 2, 6),
    2026 => Date.new(2026, 2, 1),
    2027 => Date.new(2027, 2, 8)
  },
  "十五夜" => {
    2025 => Date.new(2025, 10, 6),
    2026 => Date.new(2026, 9, 25),
    2027 => Date.new(2027, 9, 15)
  },
  "十三夜" => {
    2025 => Date.new(2025, 11, 2),
    2026 => Date.new(2026, 10, 23),
    2027 => Date.new(2027, 10, 12)
  }
}

manual_dates.each do |name, dates|
  template = ::EventTemplates::EventTemplate.find_by(name: name)
  next unless template

  dates.each do |year, date|
    create_event(template, date: date, year: date.year)
  end
end

# holiday_jp
years.each do |year|
  HolidayJp.between(Date.new(year, 1, 1), Date.new(year, 12, 31)).each do |holiday|
    template = ::EventTemplates::EventTemplate.find_by(name: holiday.name)

    if template
      ::Events::Event.find_or_create_by!(
        event_template: template,
        date: holiday.date
      )
    end

    case holiday.name
    when "春分の日"
      spring_higan = ::EventTemplates::EventTemplate.find_by(name: "春彼岸")
      next unless spring_higan

      (-3..3).each do |offset|
        ::Events::Event.find_or_create_by!(
          event_template: spring_higan,
          date: holiday.date + offset
        )
      end

    when "秋分の日"
      autumn_higan = ::EventTemplates::EventTemplate.find_by(name: "秋彼岸")
      next unless autumn_higan

      (-3..3).each do |offset|
        ::Events::Event.find_or_create_by!(
          event_template: autumn_higan,
          date: holiday.date + offset
        )
      end
    end
  end
end
