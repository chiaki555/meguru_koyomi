module EventTemplateFoods
  class EventTemplateFood < ApplicationRecord
    belongs_to :event_template, class_name: "::EventTemplates::EventTemplate"
    belongs_to :event_food, class_name: "::EventFoods::EventFood"
  end
end
