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

    it "requires a positive price" do
      fabric = build(:fabric, price_cents: -1)
      expect(fabric).not_to be_valid
      expect(fabric.errors[:price]).to include("must be a positive value")
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
  end

  describe "Multi-currency handling (The Japan Test 🇯🇵)" do
    it "formats USD with two decimal places ($150.00)" do
      fabric = build(:fabric, price_cents: 15000, currency: "USD")
      expect(fabric.price.format).to eq("$150.00")
    end

    it "formats JPY without decimal places (¥15,000)" do
      fabric = build(:fabric, price_cents: 15000, currency: "JPY")
      expect(fabric.price.format).to eq("¥15,000")
    end
  end

  describe "Rails 8 features" do
    it "automatically strips whitespace from name" do
      fabric = create(:fabric, name: "    Scabal    ")
      expect(fabric.name).to eq("Scabal")
    end
  end

  describe "enums & scopes" do
    it "defaults to standard quality" do
      expect(described_class.new.quality_grade).to eq("standard")
    end

    it "filters premium fabrics (> 20000 cents)" do
      create(:fabric, price_cents: 25000, currency: "USD")
      create(:fabric, price_cents: 10000, currency: "USD")
      expect(described_class.premium.count).to eq(1)
    end
  end
end
