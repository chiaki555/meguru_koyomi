# 行事食を複数行事にまとめて紐づけ
def attach_food_to_events(food_name, event_names)
  food = ::EventFoods::EventFood.find_or_create_by!(name: food_name)
  event_names.each do |event_name|
    event = ::EventTemplates::EventTemplate.find_by(name: event_name)
    next unless event

    ::EventTemplateFoods::EventTemplateFood.find_or_create_by!(
      event_template: event,
      event_food: food
    )
  end
end

# おすすめスポットを複数行事にまとめて紐づけ
def attach_spot_to_events(spot_name, event_names)
  spot = ::RecommendedSpots::RecommendedSpot.find_or_create_by!(name: spot_name)
  event_names.each do |event_name|
    event = ::EventTemplates::EventTemplate.find_by(name: event_name)
    next unless event

    ::EventTemplateSpots::EventTemplateSpot.find_or_create_by!(
      event_template: event,
      recommended_spot: spot
    )
  end
end
