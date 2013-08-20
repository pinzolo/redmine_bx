# coding: utf-8
module BxController
  extend ActiveSupport::Concern

  included do
    before_filter :find_project, :authorize, :set_bx_tab_to_params
    menu_item :bx
  end

  module ClassMethods
    def bx_tab(tab)
      @bx_tab_item = tab
    end

    def bx_tab_item
      @bx_tab_item
    end
  end

  private
  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def set_bx_tab_to_params
    params[:tab] ||= self.class.bx_tab_item
  end
end
