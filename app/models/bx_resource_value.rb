# coding: utf-8
class BxResourceValue < ActiveRecord::Base
  unloadable

  belongs_to :resource, :class_name => "BxResourceNode", :foreign_key => :node_id
  belongs_to :branch, :class_name => "BxResourceBranch", :foreign_key => :branch_id
end
