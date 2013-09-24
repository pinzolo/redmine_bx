# coding: utf-8
class CreateBxCommonColumnDefs < ActiveRecord::Migration
  def change
    create_table :bx_common_column_defs do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :table_group_id, :null => false, :default => 0
      t.string :logical_name, :null => false, :default => ""
      t.string :physical_name, :null => false, :default => ""
      t.integer :data_type_id, :null => false, :default => 0
      t.integer :size, :null => false, :default => 0
      t.integer :scale, :null => false, :default => 0
      t.boolean :nullable, :null => false, :default => false
      t.string :default_value, :null => false, :default => ""
      t.integer :reference_column_id, :null => false, :default => 0
      t.integer :primary_key_number, :null => true, :default => 0
      t.string :type, :null => false, :default => ""
      t.integer :position, :null => false, :default => 0
      t.text :note, :null => false, :default => ""
    end

    add_index :bx_common_column_defs, :table_group_id
    add_index :bx_common_column_defs, [:table_group_id, :physical_name], :unique => true
  end
end
