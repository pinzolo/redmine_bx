# coding: utf-8
class BxRootResourcesController < ApplicationController
  include BxController
  unloadable

  bx_tab :bx_resources

  def show
  end

  def new
    @form = BxRootResourceForm.new
  end

  def create
    @form = BxRootResourceForm.new(params[:form].merge(:project => @project))
    @result = BxResourceService.new(@form).create_root!
    if @result.success?
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_resources_root_path(@project, @result.data)
    elsif @result.invalid_input?
      render :action => :new
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end

  def edit
  end

  def update
  end
end
