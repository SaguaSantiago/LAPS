class CreateQuotas < ActiveRecord::Migration[7.0]
  def change
    create_table :quotas do |t|
      t.references :transaction, null: false, foreign_key: true  # usamos 'transaction'
      t.integer :number
      t.boolean :state, default: false
      t.float :quota_mount
      t.timestamps
    end
  end
end

