# coding: utf-8
class BxResourceCategory < ActiveRecord::Base
  unloadable

  has_many :branches, :class_name => "BxResourceBranch", :foreign_key => :category_id

  def histories
    @histories ||= BxHistory.where(:target => "resource_category", :source_id => self.id)
  end

  def resources
    @resources ||= BxResourceNode.where(:category_id => self.id, :parent_id => 0)
  end
end
