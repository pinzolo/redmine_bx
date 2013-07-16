# coding: utf-8
class BxMenuController < ApplicationController
  unloadable

  before_filter :find_project, :authorize

  def index
  end

  private
  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
