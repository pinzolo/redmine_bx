# coding: utf-8
class CreateBxResourceValues < ActiveRecord::Migration
  def change
    create_table :bx_resource_values do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :node_id, :null => false, :default => 0
      t.integer :branch_id, :null => false, :default => 0
      t.string :value, :null => false, :default => ""
    end

    add_index :bx_resource_values, :node_id
    add_index :bx_resource_values, [:node_id, :branch_id], :unique => true
  end
end
