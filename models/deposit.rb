class Deposit < Transaction
    belongs_to :target_account, class_name: 'Account'

    validates :deposit_method, presence: true

    after_create :apply_deposit

    private 

    def apply_deposit
        ActiveRecord::Base.transaction do
        target_account.balance += amount
        target_account.save!
        end
    end
end
