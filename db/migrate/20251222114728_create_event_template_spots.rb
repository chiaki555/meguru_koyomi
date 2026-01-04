class CreateEventTemplateSpots < ActiveRecord::Migration[8.1]
  def change
    create_table :event_template_spots do |t|
      t.references :event_template, null: false, foreign_key: true
      t.references :recommended_spot, null: false, foreign_key: true
    end

    add_index :event_template_spots, [ :event_template_id, :recommended_spot_id ], unique: true
  end
end
