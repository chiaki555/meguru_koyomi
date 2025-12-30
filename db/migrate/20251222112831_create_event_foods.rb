class CreateEventFoods < ActiveRecord::Migration[8.1]
  def change
    create_table :event_foods do |t|
      t.string :name

      t.timestamps
    end

    add_index :event_foods, :name, unique: true
  end
end
