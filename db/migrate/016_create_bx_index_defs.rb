# coding: utf-8
class CreateBxIndexDefs < ActiveRecord::Migration
  def change
    create_table :bx_index_defs do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :table_id, :null => false, :default => 0
      t.string :logical_name, :null => false, :default => ""
      t.string :physical_name, :null => false, :default => ""
      t.text :description, :null => false, :default => ""
    end

    add_index :bx_index_defs, :table_id
    add_index :bx_index_defs, [:table_id, :physical_name], :unique => true
  end
end
