class AddCategoryAssociations < ActiveRecord::Migration[8.0]
  def change
    add_reference :categorys, :account, foreign_key: true
    add_reference :categorys, :event, foreign_key: true
    add_reference :categorys, :transaction, foreign_key: true
  end
end
