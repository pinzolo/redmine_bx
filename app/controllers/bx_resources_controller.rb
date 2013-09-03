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
    @resource = BxResourceNode.find(params[:id])
    @form = BxResourceForm.new(:category_id => @resource.category_id)
    @resource.values.each do |value|
      @form.branch_values[value.branch_id] = value.value
    end
    @form.load(:resource => @resource)
  end

  def update
    @resource = BxResourceNode.find(params[:id])
    @form = BxResourceForm.new(params[:form].merge(:project_id => @project.id, :base_resource => @resource))
    @result = BxResourceService.new(@form).update_resource!(@resource)
    if @result.success?
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_bx_resource_path(@project, @resource)
    elsif @result.invalid_input?
      render :action => :edit
    elsif @result.conflict?
      flash.now[:error] = l(:notice_locking_conflict)
      render :action => :edit
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end

  def destroy
  end
end
