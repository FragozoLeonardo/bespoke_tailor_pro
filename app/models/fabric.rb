class Fabric < ApplicationRecord
  monetize :price_cents,
           numericality: {
             greater_than_or_equal_to: 0,
             message: "must be a positive value"
           }

  validates :name, presence: true, uniqueness: true
end
