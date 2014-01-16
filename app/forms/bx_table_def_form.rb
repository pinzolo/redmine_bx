# coding: utf-8
class BxTableDefForm
  include Formup
  include BxIssuesRelation

  source :table_def, :aliases => { :project_id => :project_id,
                                   :table_group_id => :table_group_id,
                                   :physical_name => :physical_name,
                                   :logical_name => :logical_name,
                                   :description => :description,
                                   :lock_version => :lock_version }

  attr_accessor :using_common_column_defs, :base_table_def

  validates :physical_name, :presence => true, :length => { :maximum => 200 }, :bx_table_def_physical_name_uniqueness => true
  validates :logical_name, :length => { :maximum => 200 }

  def handle_extra_params(params)
    self.relational_issues = params[:relational_issues]
    self.using_common_column_defs = params[:using_common_column_defs] || []
    self.base_table_def = params[:base_table_def]
  end
end

