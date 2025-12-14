class CreateSeasonalBathTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :seasonal_bath_templates do |t|
      t.string :name
      t.text :description
      t.integer :month # 固定日用
      t.integer :day # 固定日用
      t.integer :date_type # 固定0、変動1

      t.timestamps
    end
  end
end
