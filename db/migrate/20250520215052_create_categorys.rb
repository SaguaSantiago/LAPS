class CreateCategorys < ActiveRecord::Migration[8.0]
  def change
    create_table :categorys do |t|
      t.string :name
      t.string :description
      t.string :color # Hexadecimal color code
      t.string :icon
    end
  end
end
