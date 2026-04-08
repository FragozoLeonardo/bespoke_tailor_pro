require 'rails_helper'

RSpec.describe Fabric, type: :model do
  it { is_expected.to monetize(:price_cents).with_model_currency(:currency) }

  describe "validations" do
    it "is valid with standard attributes" do
      expect(build(:fabric)).to be_valid
    end

    it "requires a name" do
      expect(build(:fabric, name: nil)).not_to be_valid
    end

    it "requires a non-negative price" do
      fabric = build(:fabric, price_cents: -1)
      expect(fabric).not_to be_valid
      expect(fabric.errors[:price_cents]).to include("cannot be negative")
    end

    it "enforces unique names ignoring case and spaces" do
      create(:fabric, name: "Loro Piana")
      duplicate = build(:fabric, name: "  loro piana  ")
      expect(duplicate).not_to be_valid
    end

    it "requires a valid currency" do
      invalid_fabric = build(:fabric, currency: "XYZ")
      expect(invalid_fabric).not_to be_valid
      expect(invalid_fabric.errors[:currency]).to include("is not included in the list")
    end

    it "does not allow high value price with standard quality" do
      fabric = build(:fabric, price_cents: 25_000, quality_grade: :standard)

      expect(fabric).not_to be_valid
      expect(fabric.errors[:quality_grade]).to include("must be a higher grade for high-value fabrics")
    end
  end

  describe "multi-currency handling" do
    it "formats USD with two decimal places ($150.00)" do
      fabric = build(:fabric, price_cents: 15000, currency: "USD")
      expect(fabric.price.format).to eq("$150.00")
    end

    it "formats JPY without decimal places" do
      fabric = build(:fabric, price_cents: 15000, currency: "JPY")
      expect(fabric.price.format).to include("15,000")
    end
  end

  describe "rails 8 features" do
    it "automatically strips whitespace from name" do
      fabric = create(:fabric, name: "    Scabal    ")
      expect(fabric.name).to eq("Scabal")
    end
  end

  describe "enums & scopes" do
    it "defaults to standard quality" do
      expect(described_class.new.quality_grade).to eq("standard")
    end

    it "filters high value fabrics" do
      create(:fabric, price_cents: 25_000, quality_grade: :elite)
      create(:fabric, price_cents: 10_000, quality_grade: :standard)

      expect(described_class.high_value.count).to eq(1)
    end
  end
end
