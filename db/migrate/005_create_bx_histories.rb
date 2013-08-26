# coding: utf-8
class CreateBxHistories < ActiveRecord::Migration
  def change
    create_table :bx_histories do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.string :target, :null => false, :default => ""
      t.string :operation_type, :null => false, :default => ""
      t.string :operation, :null => false, :default => ""
      t.string :key, :null => false, :default => ""
      t.integer :source_id, :null => false, :default => 0
      t.integer :changed_by, :null => false, :default => 0
      t.datetime :changed_at, :null => false
    end

    add_index :bx_histories, [:target, :source_id]
  end
end
