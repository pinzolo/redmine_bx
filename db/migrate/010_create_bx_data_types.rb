# coding: utf-8
class CreateBxDataTypes < ActiveRecord::Migration
  def change
    create_table :bx_data_types do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.string :name, :null => false, :default => ""
      t.integer :database_id, :null => false, :default => 0
      t.boolean :sizable, :null => false, :default => true
      t.boolean :scalable, :null => false, :default => false
      t.boolean :default_use, :null => false, :default => false
    end

    add_index :bx_data_types, :database_id
    add_index :bx_data_types, [:database_id, :name], :unique => true
  end
end
