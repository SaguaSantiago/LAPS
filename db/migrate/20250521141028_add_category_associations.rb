class AddCategoryAssociations < ActiveRecord::Migration[7.0]
  def change
    add_reference :categories, :account, foreign_key: true
    add_reference :categories, :event, foreign_key: true
    add_reference :categories, :transaction, foreign_key: true
  end
end
