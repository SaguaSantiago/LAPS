class Loan < Transaction
    belongs_to :source_account, class_name: 'Account'
    belongs_to :target_account, class_name: 'Account'
    has_many :quotas, class_name: 'Quota', dependent: :destroy

    validates :expiration_period, presence: true
    validates :quotas_number, presence: true, numericality: { greater_than: 0 }

end