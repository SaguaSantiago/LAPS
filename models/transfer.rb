class Tranfer < Transaction
    belongs_to :source_account, class_name: 'Account'
    belongs_to :target_account, class_name: 'Account'

    validates :method, presence: true
    valdiates :has_sufficient_balance

    private 

    def has_sufficient_balance
        if source_account.balance < amount
            errors.add("no tienes suficiente dinero")
        end
    end

end