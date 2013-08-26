# coding: utf-8
class BxResourceBranch < ActiveRecord::Base
  unloadable

  belongs_to :root_node, :class_name => "BxResourceNode", :foreign_key => :root_node_id
end
