require 'rails_helper'

RSpec.describe Fabric, type: :model do
  it "is valid with a name, price_cents, and currency" do
    fabric = Fabric.new(name: "Italian Wool", price_cents: 15000, currency: "USD")
    expect(fabric).to be_valid
  end

  it "is invalid without a name" do
    fabric = Fabric.new(name: nil)
    fabric.valid?
    expect(fabric.errors[:name]).to include("can't be blank")
  end
end
