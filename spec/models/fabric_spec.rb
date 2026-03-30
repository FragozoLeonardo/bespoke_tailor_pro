require 'rails_helper'

RSpec.describe Fabric, type: :model do
  it { is_expected.to monetize(:price_cents) }

  it "is valid with a name and a positive price" do
    fabric = Fabric.new(name: "Italian Wool", price_cents: 15000)
    expect(fabric).to be_valid
  end

  it "is invalid without a name" do
    fabric = Fabric.new(name: nil)
    expect(fabric).not_to be_valid
    expect(fabric.errors[:name]).to include("can't be blank")
  end

  it "is invalid with a negative price" do
    fabric = Fabric.new(name: "Linen", price_cents: -500)
    expect(fabric).not_to be_valid
    expect(fabric.errors[:price]).to include("must be a positive value")
  end
end
