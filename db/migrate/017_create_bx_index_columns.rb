# coding: utf-8
class CreateBxIndexColumns < ActiveRecord::Migration
  def change
    create_table :bx_index_columns do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :index_def_id, :null => false, :default => 0
      t.integer :column_def_id, :null => false, :default => 0
      t.integer :position, :null => false, :default => 0
    end

    add_index :bx_index_columns, :index_def_id
    add_index :bx_index_columns, :column_def_id
    add_index :bx_index_columns, [:index_def_id, :column_def_id], :unique => true
    add_index :bx_index_columns, [:index_def_id, :position], :unique => true
  end
end
