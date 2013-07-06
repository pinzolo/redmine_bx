# coding: utf-8
class CreateBxHistoryIssues < ActiveRecord::Migration
  def change
    create_table :bx_history_issues do |t|
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps

      t.integer :history_id, :null => false, :default => 0
      t.integer :issue_id, :null => false, :default => 0
    end

    add_index :bx_history_issues, :history_id
  end
end
