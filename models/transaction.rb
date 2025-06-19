class Transaction < ActiveRecord::Base
    belongs_to :account
    belongs_to :category
    belongs_to :source_account, class_name: 'Account', optional: true
    belongs_to :target_account, class_name: 'Account', optional: true
    validates :amount, presence: true, numericality: { greater_than: 0 }
end
