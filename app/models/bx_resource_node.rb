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

  before_save :build_default_path

  acts_as_searchable :columns => ["#{table_name}.default_path", "#{table_name}.summary", "#{BxResourceValue.table_name}.value"],
                     :include => [:project, :values],
                     :date_column => "#{table_name}.created_at",
                     :permission => :view_bx_resource_nodes
  acts_as_event :title => Proc.new { |o| o.default_path + (o.summary.present? ? " : #{o.summary}" : "") },
                :url => Proc.new { |o| { :controller => "bx_resources", :action => :show, :project_id => o.project.identifier, :id => o.id } },
                :description => Proc.new { |o| o.summary },
                :datetime => :created_at

  def depth
    @depth ||= self.default_path.split(":").length
  end

  def descendants
    @descendants ||= BxResourceNode.where(:category_id => self.category_id)
                                   .where("#{self.class.table_name}.default_path LIKE ?", "#{self.default_path}:%")
                                   .order(:default_path).includes(:parent, :values)
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
    branch_id = branch.is_a?(BxResourceBranch) ? branch.id : branch
    values.where(:branch_id => branch_id).first.try(:value)
  end

  def path(delimiter = ":")
    if delimiter == ":" || delimiter.nil? || delimiter.length.zero?
      default_path
    else
      ancestry.map(&:code).join(delimiter)
    end
  end

  def build_default_path
    self.default_path = parent ? "#{parent.default_path}:#{code}" : code
  end
end
