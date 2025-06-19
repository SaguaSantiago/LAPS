class Category < ActiveRecord::Base
    validates :name, presence: true
    validates :color, presence: true
    validates :unioque_color_per_account, uniqueness: { scope: :account_id, message: 'ya existe en esta cuenta una categoria con ese color' }
    validates :unique_name_account, uniqueness: { scope: :account_id, message: 'ya existe en esta cuenta una categoría con ese nombre' }
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

    def unioque_color_per_account
      if color.present? && account_id.present?
        if Category.where(account_id: account_id)
                   .where(color: color)
                   .where.not(id: id)
                   .exists?
          errors.add(:color, 'ya existe en esta cuenta una categoría con ese color')
        end
      end
    end
end