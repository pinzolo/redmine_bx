# coding: utf-8
class CreateBxResourceNodes < ActiveRecord::Migration
  def change
    create_table :bx_resource_nodes do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :project_id, :null => false, :default => 0
      t.integer :parent_id, :null => false, :default => 0
      t.integer :category_id, :null => false, :default => 0
      t.string :code, :null => false, :default => ""
      t.string :summary, :null => false, :default => ""
    end

    add_index :bx_resource_nodes, :project_id
    add_index :bx_resource_nodes, :parent_id
    add_index :bx_resource_nodes, :category_id
    add_index :bx_resource_nodes, [:project_id, :parent_id, :code], :unique => true
  end
end
