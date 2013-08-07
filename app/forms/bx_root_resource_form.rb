# coding: utf-8
class BxRootResourceForm
  include Formup

  source :resource, :attributes => [:id, :summary, :code]

  attr_accessor :project

  validates :resource_code, :presence => true
  validates :resource_summary, :presence => true

  def handle_extra_params(params)
    self.project = params[:project]
  end
end
