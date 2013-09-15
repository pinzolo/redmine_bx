# coding: utf-8
class CreateBxResourceBranches < ActiveRecord::Migration
  def change
    create_table :bx_resource_branches do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :category_id, :null => false, :default => 0
      t.string :name, :null => false, :default => ""
      t.string :code, :null => false, :default => ""
    end

    add_index :bx_resource_branches, :category_id
    add_index :bx_resource_branches, [:category_id, :code], :unique => true
  end
end
