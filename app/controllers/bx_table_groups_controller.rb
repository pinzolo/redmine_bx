# coding: utf-8
class BxTableGroupsController < ApplicationController
  include BxController
  unloadable

  bx_tab :bx_table_defs

  def show
    @table_group = BxTableGroup.find(params[:id])
  end

  def new
    @databases = BxDatabase.all(:include => :data_types, :order => :name)
    @form = BxTableGroupForm.new
  end

  def create
    @form = BxTableGroupForm.new(params[:form].merge(:project_id => @project.id))
    @result = BxTableDefService.new(@form).create_table_group!
    if @result.success?
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_bx_table_group_path(@project, @result.data)
    elsif @result.invalid_input?
      @databases = BxDatabase.all(:include => :data_types, :order => :name)
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
