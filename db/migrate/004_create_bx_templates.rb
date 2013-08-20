# coding: utf-8
class CreateBxTemplates < ActiveRecord::Migration
  def change
    create_table :bx_templates do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :project_id, :null => false, :default => 0
      t.string :target, :null => false, :default => ""
      t.string :name, :null => false, :default => ""
      t.string :file_name, :null => false, :default => ""
      t.text :content, :null => false, :default => ""
      t.boolean :allow_direct, :null => false, :default => true
    end

    add_index :bx_templates, :project_id
    add_index :bx_templates, [:project_id, :file_name], :unique => true
  end
end
