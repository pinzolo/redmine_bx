# coding: utf-8
class BxResourceNode < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :parent, :class_name => "BxResourceNode"
  belongs_to :category, :class_name => "BxResourceCategory"
  has_many :children, :class_name => "BxResourceNode", :foreign_key => :parent_id, :order => :code, :include => :values
  has_many :values, :class_name => "BxResourceValue", :foreign_key => :node_id
  has_many :histories, :class_name => "BxHistory", :foreign_key => :source_id,
                       :conditions => Proc.new { ["target = ?", "resource"] }, :include => [:details, :issues]
  delegate :branches, :to => :category

  before_save :set_path

  acts_as_searchable :columns => ["path", "summary", "#{BxResourceValue.table_name}.value"],
                     :include => [:project, :values],
                     :date_column => "#{table_name}.created_at",
                     :permission => :view_bx_resource_nodes
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

  def value(branch)
    self.values.detect { |value| value.branch_id == branch.id }.try(:value)
  end

  private
  def set_path
    self.path = self.ancestry.map(&:code).join(":")
  end
end
