# coding: utf-8
class BxResourceBranchForm
  include Formup
  include BxIssuesRelation

  source :branch, :attributes => [:id], :aliases => { :name => :name, :code => :code, :root_node_id => :root_node_id }

  validates :name, :presence => true, :length => { :maximum => 255 }
  validates :code, :presence => true, :length => { :maximum => 255 }, :bx_resource_branch_code_uniqueness => true

  def handle_extra_params(params)
    self.relational_issues = params[:relational_issues]
  end
end
