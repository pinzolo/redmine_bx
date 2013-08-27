# coding: utf-8
class CreateBxResourceCategories < ActiveRecord::Migration
  def change
    create_table :bx_resource_categories do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :project_id, :null => false, :default => 0
      t.string :name, :null => false, :default => ""
      t.text :description, :null => false, :default => ""
    end
  end
end
