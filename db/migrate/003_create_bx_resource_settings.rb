# coding: utf-8
class CreateBxResourceSettings < ActiveRecord::Migration
  def change
    create_table :bx_resource_settings do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :root_node_id, :null => false, :default => 0
      t.boolean :use_code_pattern, :null => false, :default => false
      t.string :code_pattern, :null => false, :default => ""
    end

    add_index :bx_resource_settings, :root_node_id, :unique => true
  end
end
