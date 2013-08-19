# coding: utf-8
class BxRootResourceForm
  include Formup
  include BxIssuesRelation

  source :resource, :attributes => [:id, :summary, :code]

  attr_accessor :project

  validates :resource_code, :presence => true, :length => { :maximum => 255 }, :bx_resource_code_uniqueness => true
  validates :resource_summary, :presence => true, :length => { :maximum => 255 }

  def handle_extra_params(params)
    self.project = params[:project]
    self.relational_issues = params[:relational_issues]
  end

  def resource_parent_id
    BxResourceNode::PARENT_ID_OF_ROOT
  end
end
