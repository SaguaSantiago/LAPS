class Quota < ActiveRecord::Base
  self.table_name = 'quotas'
  belongs_to :loan, -> { where(type: 'Loan') }, class_name: 'Transaction', foreign_key: 'transaction_id'
end

