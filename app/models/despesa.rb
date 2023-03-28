class Despesa < ApplicationRecord
    validates :observacao, presence: true
    validates :tipo, presence: true
    validates :valor, presence: true
end
