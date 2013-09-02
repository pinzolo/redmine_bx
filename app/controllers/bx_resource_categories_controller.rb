# coding: utf-8
class BxResourceCategoriesController < ApplicationController
  include BxController
  unloadable

  bx_tab :bx_resources

  def show
    @category = BxResourceCategory.find(params[:id])
  end

  def new
    @form = BxResourceCategoryForm.new
  end

  def create
    @form = BxResourceCategoryForm.new(params[:form].merge(:project_id => @project.id))
    @result = BxResourceService.new(@form).create_category!
    if @result.success?
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_bx_category_path(@project, @result.data)
    elsif @result.invalid_input?
      render :action => :new
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end

  def edit
    @category = BxResourceCategory.find(params[:id])
    @form = BxResourceCategoryForm.new
    @form.load(:category => @category)
  end

  def update
    @form = BxResourceCategoryForm.new(params[:form].merge(:project_id => @project.id))
    @category = BxResourceCategory.find(params[:id])
    @result = BxResourceService.new(@form).update_category!(@category)
    if @result.success?
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_bx_category_path(@project, @category)
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
    @category = BxResourceCategory.find(params[:id])
    BxResourceService.new.delete_category!(@category)
    flash[:notice] = l(:notice_successful_delete)
    redirect_to project_bx_resources_path(@project)
  end
end
