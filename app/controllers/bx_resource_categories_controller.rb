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
  end

  def update
  end

  def destroy
  end
end
