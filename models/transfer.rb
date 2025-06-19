class Transfer < Transaction
    belongs_to :source_account, class_name: 'Account'
    belongs_to :target_account, class_name: 'Account'

    validates :transfer_method, presence: true
    validate :has_sufficient_balance

    after_create :apply_transfer 

    private 

    def has_sufficient_balance
        if source_account.balance < amount
            errors.add(:base,"no tienes suficiente dinero")
        end
    end

    def apply_transfer 
        ActiveRecord::Base.transaction do 
            source_account.balance -= amount
            source_account.save!

            target_account.balance += amount
            target_account.save!
        end
    end
end
