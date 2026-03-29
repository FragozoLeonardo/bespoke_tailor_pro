class Fabric < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
