class Fabric < ApplicationRecord
  self.strict_loading_by_default = true

  monetize :price_cents,
           with_model_currency: :currency,
           numericality: {
             greater_than_or_equal_to: 0,
             message: "must be a positive value"
           }

  normalizes :name, with: ->(name) { name.strip }

  enum :quality_grade, {
    standard: 0,
    super_100s: 100,
    super_120s: 120,
    super_150s: 150
  }, default: :standard

  # Scopes e Validations
  scope :premium, -> { where("price_cents > ?", 20000) }
  scope :by_quality, ->(grade) { where(quality_grade: grade) }
  scope :alphabetical, -> { order(:name) }

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :currency, presence: true, inclusion: { in: %w[USD JPY BRL EUR] }
end
