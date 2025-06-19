class Account < ActiveRecord::Base
  belongs_to :user
  has_many :transactions

   attribute :balance, :decimal, default: 0.0
  attribute :credit_limit, :decimal, default: 100_000.00


  validates :cvu, presence: true, uniqueness: true
  validates :alias, presence: true, uniqueness: true

 

 # def available_credit
 #   (credit_limit || 0.0) - (loans_used || 0.0)
 #end

 # def loans_used
 #   transactions.where(transaction_type: "Loan").sum(:amount)
 # end


  def actualizar_balance(cantidad)
    self.balance ||= 0.0  
    nuevo_balance = self.balance + cantidad
    if nuevo_balance >= 0
      self.balance = nuevo_balance
      save
    else
      errors.add(:balance, "no puede quedar en negativo")
      false
    end
  end
end