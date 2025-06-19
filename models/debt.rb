class Debt < Transaction
    belongs_to :source_account, class_name: 'Account'
    belongs_to :target_account, class_name: 'Account'

    validates :maturity_date, presence: true
    validate :has_sufficient_balance
    
    after_create :apply_debt

    private 

    def has_sufficient_balance
        if source_account.balance < amount
            errors.add(:base, "no tienes suficiente dinero")
        end
    end
    
    #Callback para descontar saldo de deuda
    def apply_debt
    ActiveRecord::Base.transaction do
      source_account.balance -= amount
      source_account.save!
      end
    end
end
