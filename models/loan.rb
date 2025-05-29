class Loan < Transaction
    belongs_to :source_account, class_name: 'Account'
    belongs_to :target_account, class_name: 'Account'
    has_many :quotas, class_name: 'Quota', dependent: :destroy

    validates :expiration_period, presence: true
    validates :quotas_number, presence: true, numericality: { greater_than: 0 }
    
    #Callback para que cuando se cree el préstamo, se acredite el dinero a la cuenta destino
    afert_create :apply_loan
    
    private
    def apply_loan
    	ActiveRecord: :Base.transaction do
    	 target_account.balance += amount
    	 target_account.save!
    	end
    end
end
