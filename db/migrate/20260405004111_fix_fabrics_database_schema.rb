class FixFabricsDatabaseSchema < ActiveRecord::Migration[8.1]
  def change
    change_column :fabrics, :quality_grade, :integer,
                  default: 0,
                  null: false,
                  using: "quality_grade::integer"

    remove_index :fabrics, :name if index_exists?(:fabrics, :name)
    execute "CREATE UNIQUE INDEX index_fabrics_on_lower_name ON fabrics (LOWER(name));"
  end
end
