class Transaction < ActiveRecord::Base
    self.abstract_class = true
    belongs_to :account
    validates :amount, presence: true, numericality: { greater_than: 0 }

end