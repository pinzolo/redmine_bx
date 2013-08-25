# coding: utf-8
class CreateBxHistoryDetails < ActiveRecord::Migration
  def change
    create_table :bx_history_details do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :history_id, :null => false, :default => 0
      t.string :property, :null => false, :default => ""
      t.text :old_value, :null => false, :default => ""
      t.text :new_value, :null => false, :default => ""
    end

    add_index :bx_history_details, :history_id
  end
end
