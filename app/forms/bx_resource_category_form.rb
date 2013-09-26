# coding: utf-8
class BxResourceCategoryForm
  include Formup
  include BxIssuesRelation

  source :category, :aliases => { :project_id => :project_id, :name => :name, :description => :description, :lock_version => :lock_version }

  validates :name, :presence => true, :length => { :maximum => 200 }

  def handle_extra_params(params)
    self.relational_issues = params[:relational_issues]
  end
end
