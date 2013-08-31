# coding: utf-8
class BxResourceNode < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :parent, :class_name => "BxResourceNode", :foreign_key => :parent_id
  belongs_to :category, :class_name => "BxResourceCategory", :foreign_key => :category_id
  has_many :children, :class_name => "BxResourceNode", :foreign_key => :parent_id
  has_many :values, :class_name => "BxResourceValue", :foreign_key => :node_id

  def leaf?
    !self.values.empty?
  end

  def depth
    @depth ||= self.parent.nil? ? 0 : self.parent.depth + 1
  end

  def ancestry
    @ancestry ||= begin
      list = []
      node = self
      while node.present?
        list.unshift(node)
        node = node.parent
      end
      list
    end
  end

  def path(delimiter)
    self.ancestry.map { |node| node.code }.join(delimiter)
  end

  def histories
    @histories ||= BxHistory.where(:target => "resource", :source_id => self.id)
  end
end
