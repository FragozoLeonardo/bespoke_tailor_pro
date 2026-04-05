class Fabric < ApplicationRecord
  monetize :price_cents, with_model_currency: :currency

  PREMIUM_THRESHOLD_CENTS = 20_000

  normalizes :name, with: ->(name) { name&.strip }

  enum :quality_grade, {
    standard: 0,
    super_100s: 100,
    super_120s: 120,
    super_150s: 150
  }

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :currency, presence: true, inclusion: { in: %w[USD JPY EUR BRL] }
  validates :price_cents, numericality: {
    greater_than_or_equal_to: 0,
    message: "must be a positive value"
  }

  validate :premium_requires_high_quality

  scope :premium, -> { where(price_cents: PREMIUM_THRESHOLD_CENTS..) }

  def premium?
    price_cents.to_i >= PREMIUM_THRESHOLD_CENTS
  end

  private

  def premium_requires_high_quality
    if premium? && standard?
      errors.add(:quality_grade, "must be a superior grade for premium pricing")
    end
  end
end
