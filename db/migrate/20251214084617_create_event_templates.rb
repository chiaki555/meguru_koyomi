class CreateEventTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :event_templates do |t|
      t.string :name
      t.text :description
      t.integer :month # 固定日用
      t.integer :day # 固定日用
      t.integer :date_type # 固定日：0, 変動日：1
      t.integer :source_type # auto（holiday_jp）：0, 手動：1
      t.integer :area_type # 全国的：0, 地域的：1

      t.timestamps
    end
  end
end
