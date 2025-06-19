class Loan < Transaction
    belongs_to :source_account, class_name: 'Account'
    belongs_to :target_account, class_name: 'Account'
    has_many :quotas, class_name: 'Quota', foreign_key: 'transaction_id', dependent: :destroy

    validates :expiration_period, presence: true
    validates :quotas_number, presence: true, numericality: { greater_than: 0 }

    #Callback para que cuando se cree el préstamo, se acredite el dinero a la cuenta destino
    after_create :apply_loan
    private
    def apply_loan
    	ActiveRecord::Base.transaction do
            target_account.balance += amount
            target_account.save!
            # Calcular monto de cada cuota
      	    cuota_monto = (amount / quotas_number).round(2)
      
      	    quotas_number.times do |i|
                quotas.create!(
                number: i + 1,
                quota_mount: cuota_monto,
                state: false)
            end
    	end
    end
end

