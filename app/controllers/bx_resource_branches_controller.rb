# coding: utf-8
class BxResourceBranchesController < ApplicationController
  include BxController
  unloadable

  bx_tab :bx_resources

  def new
    @category = BxResourceCategory.find(params[:category_id])
    @form = BxResourceBranchForm.new(:category_id => @category.id)
  end

  def create
    @category = BxResourceCategory.find(params[:category_id])
    @form = BxResourceBranchForm.new(params[:form])
    @result = BxResourceService.new(@form).add_branch!
    if @result.success?
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_bx_category_path(@project, @category)
    elsif @result.invalid_input?
      render :action => :new
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end

  def edit
    @branch = BxResourceBranch.find(params[:id])
    @form = BxResourceBranchForm.new
    @form.load(:branch => @branch)
  end

  def update
    @branch = BxResourceBranch.find(params[:id])
    @form = BxResourceBranchForm.new(params[:form].merge(:base_branch => @branch))
    @result = BxResourceService.new(@form).update_branch!(@branch)
    if @result.success?
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_bx_category_path(@project, @branch.category_id)
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
    @result = BxResourceService.new.delete_branch!(@branch)
    if @result.success?
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = @result.data.message
    end
    redirect_to project_bx_category_path(@project, @branch.category_id)
  end
end
