class CreateEventTemplateFoods < ActiveRecord::Migration[8.1]
  def change
    create_table :event_template_foods do |t|
      t.references :event_template, null: false, foreign_key: true
      t.references :event_food, null: false, foreign_key: true
    end

    add_index :event_template_foods, [ :event_template_id, :event_food_id ], unique: true
  end
end
