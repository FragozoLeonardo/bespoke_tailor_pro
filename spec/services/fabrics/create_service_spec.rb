require 'rails_helper'

RSpec.describe Fabrics::CreateService, type: :service do
  let(:valid_params) { { name: "Silk", price_cents: 5000, currency: "USD", quality_grade: "premium" } }
  let(:invalid_params) { { name: "", price_cents: -10 } }

  describe "#call" do
    context "Happy Path" do
      it "creates a new fabric and returns success" do
        service = Fabrics::CreateService.new(valid_params)
        result = service.call

        expect(result).to be_success
        expect(result.data).to be_persisted
        expect(result.data.name).to eq("Silk")
      end
    end

    context "Sad Path" do
      it "returns failure when model validations fail" do
        service = Fabrics::CreateService.new(invalid_params)
        result = service.call

        expect(result).to be_failure
        expect(result.errors).to include("Name can't be blank")
      end
    end

    context "Edge Cases" do
      it "returns failure if a database connection exception occurs" do
        allow(Fabric).to receive(:new).and_raise(ActiveRecord::ConnectionFailed.new("DB Down"))

        service = Fabrics::CreateService.new(valid_params)
        result = service.call

        expect(result).to be_failure
        expect(result.errors.first).to match(/DB Down/)
      end

      it "returns failure when hitting a database unique constraint" do
        create(:fabric, name: "Silk")
        allow_any_instance_of(Fabric).to receive(:save).and_raise(ActiveRecord::RecordNotUnique)

        service = Fabrics::CreateService.new(name: "Silk")
        result = service.call

        expect(result).to be_failure
        expect(result.errors).to include("This fabric is already registered in the system.")
      end
    end
  end
end
