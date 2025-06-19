class Transaction < ActiveRecord::Base
    belongs_to :account
    belongs_to :category
    validates :amount, presence: true, numericality: { greater_than: 0 }

end