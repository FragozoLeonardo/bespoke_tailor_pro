require 'rails_helper'

RSpec.describe Fabric, type: :model do
  it { is_expected.to monetize(:price_cents) }

  describe "validations" do
    it "is valid with a name and a positive price" do
      expect(build(:fabric)).to be_valid
    end

    it "is invalid without a name" do
      fabric = build(:fabric, name: nil)
      expect(fabric).not_to be_valid
      expect(fabric.errors[:name]).to include("can't be blank")
    end

    it "is invalid with a negative price" do
      fabric = build(:fabric, price_cents: -500)
      expect(fabric).not_to be_valid
      expect(fabric.errors[:price]).to include("must be a positive value")
    end

    it "enforces unique names (case-insensitive)" do
      create(:fabric, name: "Loro Piana")
      duplicate = build(:fabric, name: "  loro piana  ")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include("has already been taken")
    end
  end

  describe "normalization (Rails 8)" do
    it "strips leading and trailing whitespace from name" do
      fabric = create(:fabric, name: "   Scabal Wool   ")
      expect(fabric.name).to eq("Scabal Wool")
    end
  end

  describe "enums" do
    it "defines valid quality grades" do
      expect(Fabric.quality_grades.keys).to include("standard", "super_100s", "super_120s", "super_150s")
    end

    it "defaults to standard quality" do
      expect(Fabric.new.quality_grade).to eq("standard")
    end
  end

  describe "monetary consistency" do
    it "uses USD as the default currency" do
      fabric = build(:fabric)
      expect(fabric.price.currency.iso_code).to eq("USD")
    end
  end

  describe "scopes" do
    it "filters premium fabrics correctly (price > $200)" do
      create(:fabric, price_cents: 25000)
      create(:fabric, price_cents: 10000)
      expect(Fabric.premium.count).to eq(1)
    end

    it "orders fabrics alphabetically by name" do
      create(:fabric, name: "Zegna")
      create(:fabric, name: "Ariston")
      expect(Fabric.alphabetical.first.name).to eq("Ariston")
    end
  end
end
