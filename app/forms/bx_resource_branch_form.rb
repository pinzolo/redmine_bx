# coding: utf-8
class BxResourceBranchForm
  include Formup
  include BxIssuesRelation

  source :branch, :aliases => { :name => :name, :code => :code, :category_id => :category_id, :lock_version => :lock_version }

  validates :name, :presence => true, :length => { :maximum => 255 }
  validates :code, :presence => true, :length => { :maximum => 255 }, :bx_resource_branch_code_uniqueness => true

  def handle_extra_params(params)
    self.relational_issues = params[:relational_issues]
  end
end