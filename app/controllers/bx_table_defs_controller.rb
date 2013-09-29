# coding: utf-8
class BxTableDefsController < ApplicationController
  include BxController
  unloadable

  bx_tab :bx_table_defs

  def index
    @table_groups = BxTableGroup.where(:project_id => @project.id).includes(:table_defs)
  end

  def show
  end

  def new
    @table_group = BxTableGroup.find(params[:table_group_id])
    @form = BxTableDefForm.new(:table_group_id => @table_group.id)
  end

  def create
    @table_group = BxTableGroup.find(params[:table_group_id])
    @form = BxTableDefForm.new(params[:form].merge(:project_id => @project.id, :table_group_id => @table_group.id))
    @result = BxTableDefService.new(@form).create_table_def!
    if @result.success?
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_bx_table_def_path(@project, @result.data)
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
