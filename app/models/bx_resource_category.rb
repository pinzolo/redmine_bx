# coding: utf-8
class BxResourceCategory < ActiveRecord::Base
  unloadable

  has_many :branches, :class_name => "BxResourceBranch", :foreign_key => :category_id
  has_many :resources, :class_name => "BxResourceNode", :foreign_key => :category_id, :conditions => Proc.new { ["parent_id = ?", 0] }
  has_many :histories, :class_name => "BxHistory", :foreign_key => :source_id,
                       :conditions => Proc.new { ["target = ?", "resource_category"] }, :include => :details
end
