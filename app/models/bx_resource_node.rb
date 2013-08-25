# coding: utf-8
class BxResourceNode < ActiveRecord::Base
  include BxEvacuatable
  unloadable

  PARENT_ID_OF_ROOT = 0

  evacuatable :code, :summary

  belongs_to :project
  belongs_to :parent, :class_name => "BxResourceNode", :foreign_key => :parent_id
  belongs_to :root_node, :class_name => "BxResourceNode", :foreign_key => :root_node_id
  has_many :children, :class_name => "BxResourceNode", :foreign_key => :parent_id
  has_many :branches, :class_name => "BxResourceBranch", :foreign_key => :root_node_id
  has_many :values, :class_name => "BxResourceValue", :foreign_key => :node_id

  scope :roots, ->(project) do
    project_id = project.is_a?(Project) ? project.id : project
    where(:project_id => project_id, :parent_id => BxResourceNode::PARENT_ID_OF_ROOT).order(:id).includes(:children)
  end

  def root?
    self.parent_id.zero?
  end

  def leaf?
    !self.values.empty?
  end

  def depth
    @depth ||= self.root? ? 0 : self.parent.depth + 1
  end

  def ancestry(include_self = true)
    @ancestry ||= begin
      list = []
      node = include_self ? self : self.parent
      while node.present?
        list.unshift(node)
        node = node.parent
      end
      list
    end
  end

  def path(delimiter, include_root = false)
    list = include_root ? self.ancestry : self.ancestry.slice(1, self.ancestry.length - 1)
    list.map { |node| node.code }.join(delimiter)
  end

  def histories
    BxHistory.where(:target => "resource", :source_id => self.id)
  end
end
