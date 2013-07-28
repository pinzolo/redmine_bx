# coding: utf-8
module BxController
  extend ActiveSupport::Concern

  included do
    before_filter :find_project, :authorize
    menu_item :bx
  end

  private
  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
