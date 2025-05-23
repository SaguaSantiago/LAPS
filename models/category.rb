class Category < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true

  belongs_to :account
  has_many :transactions
  has_many :events

end

# belongs_to :user
# has_many :source_transactions, 
# class_name: 'Transaction', foreign_key: :source_account_id