class ChangeCurrencyToBeStringInFabrics < ActiveRecord::Migration[8.1]
  def change
    change_column :fabrics, :currency, :string, limit: 3, default: "USD", null: false
  end
end
