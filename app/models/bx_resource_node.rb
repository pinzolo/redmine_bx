# coding: utf-8
class BxResourceNode < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :parent, :class_name => "BxResourceNode", :foreign_key => :parent_id
  belongs_to :root_node, :class_name => "BxResourceNode", :foreign_key => :root_node_id
  has_many :children, :class_name => "BxResourceNode", :foreign_key => :parent_id
  has_many :branches, :class_name => "BxResourceBranch", :foreign_key => :root_node_id
  has_many :values, :class_name => "BxResourceValue", :foreign_key => :node_id

  scope :roots, ->(project) do
    project_id = project.is_a?(Project) ? project.id : project
    where(:project_id => project_id, :parent_id => 0).order(:id).includes(:children)
  end

  def root?
    self.parent_id.zero?
  end

  def leaf?
    !self.values.empty?
  end
end
