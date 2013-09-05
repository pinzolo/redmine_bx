# coding: utf-8
class BxResourceNode < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :parent, :class_name => "BxResourceNode", :foreign_key => :parent_id
  belongs_to :category, :class_name => "BxResourceCategory", :foreign_key => :category_id
  has_many :children, :class_name => "BxResourceNode", :foreign_key => :parent_id, :order => :code
  has_many :values, :class_name => "BxResourceValue", :foreign_key => :node_id
  delegate :branches, :to => :category

  before_save :set_path

  acts_as_searchable :columns => ["path", "summary", "#{BxResourceValue.table_name}.value"],
                     :include => [:project, :values],
                     :order_column => "#{table_name}.id"
  acts_as_event :title => Proc.new { |o| o.path + (o.summary.present? ? " : #{o.summary}" : "") },
                :url => Proc.new { |o| { :controller => "bx_resources", :action => :show, :project_id => o.project.identifier, :id => o.id } },
                :description => Proc.new { |o| o.summary },
                :datetime => :created_at

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

  def histories
    @histories ||= BxHistory.where(:target => "resource", :source_id => self.id)
  end

  def value(branch)
    self.values.detect { |value| value.branch_id == branch.id }.try(:value)
  end

  private
  def set_path
    self.path = self.ancestry.map(&:code).join(":")
  end
end
