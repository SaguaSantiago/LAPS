class Account < ActiveRecord::Base
  belongs_to :user
  
  has_many :categories, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :validities, dependent: :destroy

  has_many :received_deposits, class_name: "Deposit", foreign_key: "target_account_id", dependent: :destroy
  has_many :loans_as_source, class_name: "Loan", foreign_key: "source_account_id", dependent: :destroy
  has_many :loans_as_target, class_name: "Loan", foreign_key: "target_account_id", dependent: :destroy
  has_many :transfers_as_source, class_name: "Transfer", foreign_key: "source_account_id", dependent: :destroy
  has_many :transfers_as_target, class_name: "Transfer", foreign_key: "target_account_id", dependent: :destroy
  has_many :debts_as_source, class_name: "Debt", foreign_key: "source_account_id", dependent: :destroy
  has_many :debts_as_target, class_name: "Debt", foreign_key: "target_account_id", dependent: :destroy



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