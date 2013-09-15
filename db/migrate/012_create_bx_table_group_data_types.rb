# coding: utf-8
class CreateBxTableGroupDataTypes < ActiveRecord::Migration
  def change
    create_table :bx_table_group_data_types do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :table_group_id, :null => false, :default => 0
      t.integer :data_type_id, :null => false, :default => 0
    end

    add_index :bx_table_group_data_types, :table_group_id
    add_index :bx_table_group_data_types, [:table_group_id, :data_type_id], :unique => true, :name => "index_bx_table_group_data_type"
  end
end
