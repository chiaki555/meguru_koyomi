class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.references :event_template, null: false, foreign_key: true
      t.date :date # 変動日用
      t.integer :year # 固定日用

      t.timestamps
    end
  end
end
