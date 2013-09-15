# coding: utf-8
class CreateBxIndexColumns < ActiveRecord::Migration
  def change
    create_table :bx_index_columns do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :index_id, :null => false, :default => 0
      t.integer :column_id, :null => false, :default => 0
    end

    add_index :bx_index_columns, :index_id
    add_index :bx_index_columns, :column_id
    add_index :bx_index_columns, [:index_id, :column_id], :unique => true
  end
end