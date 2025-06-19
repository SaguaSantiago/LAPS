class Category < ActiveRecord::Base
    validates :name, presence: true
    validates :description, presence: true
  
    belongs_to :account
    has_many :transactions
    has_many :events
    
    #Callbacks
    before_save :normalize_name
    
    private
    
    def normalize_name
     self.name = name.strip.downcase if name.present?
    end
    
    def unique_name_account
      if name.present? && account_id.present?
        if Category.where(account_id: account_id)
                   .where('LOWER(name) = ?', name.downcase)
                   .where.not(id: id)
                   .exists?
          errors.add(:name, 'ya existe en esta cuenta esa categoría')
        end
      end
    end
end