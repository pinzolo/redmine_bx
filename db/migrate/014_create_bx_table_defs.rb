# coding: utf-8
class CreateBxTableDefs < ActiveRecord::Migration
  def change
    create_table :bx_table_defs do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :project_id, :null => false, :default => 0
      t.integer :table_group_id, :null => false, :default => 0
      t.string :logical_name, :null => false, :default => ""
      t.string :physical_name, :null => false, :default => ""
      t.text :description, :null => false, :default => ""
    end

    add_index :bx_table_defs, :project_id
    add_index :bx_table_defs, :table_group_id
    add_index :bx_table_defs, [:table_group_id, :physical_name], :unique => true
  end
end
