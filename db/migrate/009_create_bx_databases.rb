# coding: utf-8
class CreateBxDatabases < ActiveRecord::Migration
  def change
    create_table :bx_databases do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.string :name, :null => false, :default => ""
    end
  end
end
