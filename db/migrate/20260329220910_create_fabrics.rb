class CreateFabrics < ActiveRecord::Migration[8.0]
  def change
    create_table :fabrics do |t|
      t.string :name, null: false
      t.integer :price_cents, default: 0, null: false
      t.string :currency, default: "USD", null: false
      t.string :quality_grade

      t.timestamps
    end
    add_index :fabrics, :name, unique: true
  end
end
