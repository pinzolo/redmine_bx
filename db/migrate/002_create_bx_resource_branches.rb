# coding: utf-8
class CreateBxResourceBranches < ActiveRecord::Migration
  def change
    create_table :bx_resource_branches do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :root_node_id, :null => false, :default => 0
      t.string :name, :null => false, :default => ""
      t.string :code, :null => false, :default => ""
    end

    add_index :bx_resource_branches, :root_node_id
    add_index :bx_resource_branches, [:root_node_id, :code], :unique => false
  end
end
