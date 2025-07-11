class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :category, foreign_key: true
      t.references :account, foreign_key: true
      t.references :event_date, foreign_key: true
      
      t.string :title
      t.text :description
      t.string :period
    end
  end
end
