# coding: utf-8
class BxHistoryIssue < ActiveRecord::Base
  unloadable

  belongs_to :history, :class_name => "BxHistory", :foreign_key => :history_id
  belongs_to :issue
end
