# coding: utf-8
class BxResourcesController < ApplicationController
  include BxController
  unloadable

  bx_tab :bx_resources

  def index
  end

  def show
    @resource = BxResourceNode.find(params[:id])
  end

  def new
    @form = BxResourceForm.new(:category_id => params[:category_id], :parent_id => params[:parent_id])
  end

  def create
    @form = BxResourceForm.new(params[:form].merge(:project_id => @project.id))
    @result = BxResourceService.new(@form).create_resource!
    if @result.success?
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_bx_resource_path(@project, @result.data)
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

  def destroy
  end
end
