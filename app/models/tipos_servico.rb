class TiposServico < ApplicationRecord
    validates :tipo, presence: true
end
