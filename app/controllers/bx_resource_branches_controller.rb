# coding: utf-8
class BxResourceBranchesController < ApplicationController
  include BxController
  unloadable

  bx_tab :bx_resources

  def new
    @resource = BxResourceNode.find(params[:resource_id])
    if @resource.root?
      @form = BxResourceBranchForm.new(:root_node_id => @resource.id)
    else
      render_404
    end
  end

  def create
    @resource = BxResourceNode.find(params[:resource_id])
    if @resource.root?
      @form = BxResourceBranchForm.new(params[:form])
      @result = BxResourceService.new(@form).add_branch!
      if @result.success?
        flash[:notice] = l(:notice_successful_create)
        redirect_to project_bx_root_resource_path(@project, @resource)
      elsif @result.invalid_input?
        render :action => :new
      elsif @result.error?
        render_error(:message => @result.data.message)
      end
    else
      render_404
    end
  end

  def edit
    @branch = BxResourceBranch.find(params[:id])
    @form = BxResourceBranchForm.new
    @form.load(:branch => @branch)
  end

  def update
    @form = BxResourceBranchForm.new(params[:form])
    @branch = BxResourceBranch.find(params[:id])
    @result = BxResourceService.new(@form).update_branch!(@branch)
    if @result.success?
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_bx_root_resource_path(@project, @branch.root_node_id)
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
    @branch = BxResourceBranch.find(params[:id])
    BxResourceService.new.delete_branch!(@branch)
    flash[:notice] = l(:notice_successful_delete)
    redirect_to project_bx_root_resource_path(@project, @branch.root_node_id)
  end
end
