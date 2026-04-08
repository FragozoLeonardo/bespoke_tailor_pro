class FabricsController < ApplicationController
  def index
    @fabrics = Fabric.order(created_at: :desc)
    @fabric = Fabric.new
  end

  def create
    result = Fabrics::CreateService.new(fabric_params).call
    @fabric = result.data

    if result.success?
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to fabrics_path, notice: "Fabric added." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("fabric_form", partial: "form", locals: { fabric: @fabric }), status: :unprocessable_entity }
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  private

  def fabric_params
    params.require(:fabric).permit(:name, :price_cents, :currency, :quality_grade)
  end
end
