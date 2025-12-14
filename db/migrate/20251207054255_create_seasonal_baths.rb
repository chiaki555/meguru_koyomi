class CreateSeasonalBaths < ActiveRecord::Migration[8.1]
  def change
    create_table :seasonal_baths do |t|
      t.references :seasonal_bath_template, null: false, foreign_key: true
      t.date :date # 変動日用
      t.integer :year # 固定日用

      t.timestamps
    end
  end
end
