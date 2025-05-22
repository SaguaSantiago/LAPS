class Loan < Transaction
    belongs_to :target_account, class_name: 'Account'

    validates :method, presence: true

end