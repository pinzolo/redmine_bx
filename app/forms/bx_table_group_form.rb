# coding: utf-8
class BxTableGroupForm
  include Formup
  include BxIssuesRelation

  source :table_group, :aliases => { :project_id => :project_id,
                                     :name => :name,
                                     :database_id => :database_id,
                                     :description => :description,
                                     :lock_version => :lock_version }
  attr_accessor :data_types

  validates :name, :presence => true, :length => { :maximum => 200 }
  validates :database_id, :presence => true
  validates :data_types, :presence => true

  def handle_extra_params(params)
    self.relational_issues = params[:relational_issues]
    self.data_types = params[:data_types] || []
  end
end

