# coding: utf-8
class CreateBxTableGroups < ActiveRecord::Migration
  def change
    create_table :bx_table_groups do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :project_id, :null => false, :default => 0
      t.integer :database_id, :null => false, :default => 0
      t.string :name, :null => false, :default => ""
      t.text :description, :null => false, :default => ""
    end

    add_index :bx_table_groups, :project_id
  end
end
