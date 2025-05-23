class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.references :account, foreign_key: true
      t.references :event, foreign_key: true
      t.references :transaction, foreign_key: true
      t.string :name
      t.string :description
      t.string :color
      t.string :icon 
    end
  end
end
