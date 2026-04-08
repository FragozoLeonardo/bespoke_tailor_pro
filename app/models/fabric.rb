class Fabric < ApplicationRecord
  monetize :price_cents, with_model_currency: :currency

  HIGH_VALUE_THRESHOLD_CENTS = 20_000
  SUPPORTED_CURRENCIES = %w[USD JPY EUR BRL].freeze

  enum :quality_grade, {
    standard: 0,
    high_grade: 100,
    premium: 120,
    elite: 150
  }, default: :standard

  normalizes :name, with: ->(name) { name&.strip }

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :currency, presence: true, inclusion: { in: SUPPORTED_CURRENCIES }
  validates :price_cents, numericality: {
    greater_than_or_equal_to: 0,
    message: "cannot be negative"
  }

  validate :high_value_requires_high_quality

  scope :high_value, -> { where(price_cents: HIGH_VALUE_THRESHOLD_CENTS..) }

  def high_value?
    price_cents.to_i >= HIGH_VALUE_THRESHOLD_CENTS
  end

  private

  def high_value_requires_high_quality
    if high_value? && standard?
      errors.add(:quality_grade, "must be a higher grade for high-value fabrics")
    end
  end
end
