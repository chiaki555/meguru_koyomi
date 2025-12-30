class CreateRecommendedSpots < ActiveRecord::Migration[8.1]
  def change
    create_table :recommended_spots do |t|
      t.string :name
      t.string :address
      t.string :url

      t.timestamps
    end

    add_index :recommended_spots, :url, unique: true
  end
end
