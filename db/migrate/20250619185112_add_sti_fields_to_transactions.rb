class AddStiFieldsToTransactions < ActiveRecord::Migration[7.0]
  def change
    # loan
    add_column :transactions, :quotas_number, :integer
    add_column :transactions, :expiration_period, :date
    add_column :transactions, :interest, :decimal, precision: 5, scale: 2

    # debt
    add_column :transactions, :maturity_date, :date
    add_column :transactions, :outstanding_balance, :decimal, precision: 15, scale: 2

    # deposit
    add_column :transactions, :deposit_method, :string
    add_column :transactions, :reference_number, :integer

    # transfer
    add_column :transactions, :transfer_method, :string
    add_column :transactions, :source_account_id, :integer
    add_column :transactions, :target_account_id, :integer

    # Foreign keys
    add_foreign_key :transactions, :accounts, column: :source_account_id
    add_foreign_key :transactions, :accounts, column: :target_account_id
  end
end

