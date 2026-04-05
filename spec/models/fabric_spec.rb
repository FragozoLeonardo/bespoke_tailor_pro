require 'rails_helper'

RSpec.describe Fabric, type: :model do
  describe "Validations & Edge Cases" do
    let(:fabric) { build(:fabric) }

    context "Happy Path" do
      it "is valid with correct attributes" do
        expect(fabric).to be_valid
      end
    end

    context "Presence & Format Validations" do
      it "is invalid without a name" do
        fabric.name = nil
        expect(fabric).not_to be_valid
        expect(fabric.errors[:name]).to include("can't be blank")
      end

      it "is invalid with an unsupported currency code" do
        fabric.currency = "CAD"
        expect(fabric).not_to be_valid
        expect(fabric.errors[:currency]).to include("is not included in the list")
      end
    end

    context "Uniqueness & Normalization" do
      it "is invalid with a duplicate name (case-insensitive)" do
        create(:fabric, name: "Silk")
        duplicate = build(:fabric, name: "silk")
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:name]).to include("has already been taken")
      end

      it "prevents duplicates despite extra whitespace" do
        create(:fabric, name: "Cashmere")
        duplicate = build(:fabric, name: "  CASHMERE  ")
        expect(duplicate).not_to be_valid
      end
    end

    context "Financial Rules & Boundary Analysis" do
      it "is invalid with a negative price_cents" do
        fabric.price_cents = -1
        expect(fabric).not_to be_valid
        expect(fabric.errors[:price_cents]).to include("cannot be negative")
      end

      it "is invalid with non-numeric price_cents" do
        fabric.price_cents = "expensive"
        expect(fabric).not_to be_valid
      end

      it "requires superior quality for premium pricing (200.00)" do
        fabric.price_cents = 20_000
        fabric.quality_grade = :standard
        expect(fabric).not_to be_valid
        expect(fabric.errors[:quality_grade]).to include("must be a superior grade for premium pricing")
      end

      it "allows standard quality for pricing just below premium" do
        fabric.price_cents = 19_999
        fabric.quality_grade = :standard
        expect(fabric).to be_valid
      end
    end

    context "Money-rails Integration" do
      it "exposes a Money object for the price attribute" do
        fabric.price_cents = 5000
        fabric.currency = "USD"
        expect(fabric.price).to be_a(Money)
        expect(fabric.price.cents).to eq(5000)
        expect(fabric.price.currency.iso_code).to eq("USD")
      end

      it "handles Japanese Yen (JPY) formatting correctly" do
        fabric.price_cents = 5000
        fabric.currency = "JPY"
        expect(fabric.price.format).to eq("¥5,000")
      end
    end
  end

  describe "Rails 8 Normalization" do
    it "automatically strips leading and trailing whitespace from name" do
      f = create(:fabric, name: "   Linen   ")
      expect(f.name).to eq("Linen")
    end
  end
end
