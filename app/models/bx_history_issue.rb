# coding: utf-8
class BxHistoryIssue < ActiveRecord::Base
  unloadable

  belongs_to :history, :class_name => "BxHistory"
  belongs_to :issue
end
