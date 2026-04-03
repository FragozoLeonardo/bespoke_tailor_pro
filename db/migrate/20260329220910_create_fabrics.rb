class CreateFabrics < ActiveRecord::Migration[8.0]
  def change
    create_table :fabrics do |t|
      t.string :name, null: false
      t.integer :price_cents, default: 0, null: false
      t.string :currency, default: "USD", null: false
      t.integer :quality_grade, default: 0, null: false

      t.timestamps
    end

    add_index :fabrics, :name, unique: true

    add_check_constraint :fabrics, "price_cents >= 0", name: "price_cents_non_negative"
  end
end
