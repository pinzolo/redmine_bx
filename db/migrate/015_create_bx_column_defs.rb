# coding: utf-8
class CreateBxColumnDefs < ActiveRecord::Migration
  def change
    create_table :bx_column_defs do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :table_def_id, :null => false, :default => 0
      t.string :logical_name, :null => false, :default => ""
      t.string :physical_name, :null => false, :default => ""
      t.integer :data_type_id, :null => false, :default => 0
      t.integer :size
      t.integer :scale
      t.boolean :nullable, :null => false, :default => false
      t.string :default_value, :null => false, :default => ""
      t.integer :common_column_def_id, :null => false, :default => 0
      t.integer :reference_column_def_id, :null => false, :default => 0
      t.integer :primary_key_number
      t.integer :position, :null => false, :default => 0
      t.text :note, :null => false, :default => ""
    end

    add_index :bx_column_defs, :table_def_id
    add_index :bx_column_defs, [:table_def_id, :physical_name], :unique => true
  end
end
