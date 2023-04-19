class Despesa < ApplicationRecord
    belongs_to :user
    
    validates :observacao, presence: true
    validates :tipo, presence: true
    validates :valor, presence: true
end
