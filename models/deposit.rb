class Loan < Transaction
    belongs_to :target_account, class_name: 'Account'

    validates :method, presence: true

    after_created :apply_deposit 

    private 

    def apply_deposit
        ActiveRecord::Base.transaction do
        target_account.balance += amount
        target_account.save!
        end
    end
end