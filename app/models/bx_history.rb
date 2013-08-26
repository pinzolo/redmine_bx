# coding: utf-8
class BxHistory < ActiveRecord::Base
  unloadable

  has_many :details, :class_name => "BxHistoryDetail", :foreign_key => :history_id
  has_many :issues_rels, :class_name => "BxHistoryIssue", :foreign_key => :history_id
  has_many :issues, :through => :issues_rels
end
