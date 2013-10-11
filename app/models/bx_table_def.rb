# coding: utf-8
class BxTableDef < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :table_group, :class_name => "BxTableGroup"
  has_many :column_defs, :class_name => "BxColumnDef", :foreign_key => :table_def_id, :order => :position, :include => :common_column_def
  has_many :index_defs, :class_name => "BxIndexDef", :foreign_key => :table_def_id, :order => :physical_name, :include => :column_defs
  has_many :histories, :class_name => "BxHistory", :foreign_key => :source_id,
                       :conditions => Proc.new { ["target = ?", "table_def"] }, :include => [:details, :issues]

  acts_as_searchable :columns => ["#{table_name}.physical_name", "#{table_name}.logical_name", "#{table_name}.description",
                                  "#{BxColumnDef.table_name}.physical_name", "#{BxColumnDef.table_name}.logical_name", "#{BxColumnDef.table_name}.note",
                                  "#{BxIndexDef.table_name}.physical_name", "#{BxIndexDef.table_name}.logical_name", "#{BxIndexDef.table_name}.note"],
                     :include => [:project, :column_defs, :index_defs],
                     :date_column => "#{table_name}.created_at",
                     :permission => :view_bx_resource_nodes
  acts_as_event :title => Proc.new { |o| o.physical_name + (o.logical_name.present? ? " : [#{o.logical_name}]" : "") },
                :url => Proc.new { |o| { :controller => "bx_table_defs", :action => :show, :project_id => o.project.identifier, :id => o.id } },
                :description => Proc.new { |o| o.description },
                :datetime => :created_at
end
