# coding: utf-8
class BxColumnDefsController < ApplicationController
  include BxController
  unloadable

  bx_tab :bx_table_defs

  def new
    @table_defs = BxTableDef.where(:project_id => @project.id).order(:physical_name)
    @table_def = BxTableDef.find(params[:table_def_id])
    @form = BxColumnDefForm.new(:table_id => @table_def.id)
  end

  def create
    @table_defs = BxTableDef.where(:project_id => @project.id).order(:physical_name)
    @table_def = BxTableDef.find(params[:table_def_id])
    @form = BxColumnDefForm.new(params[:form].merge(:table_group_id => @table_def.table_group_id, :table_id => @table_def.id))
    @result = BxTableDefService.new(@form).create_column_def!
    if @result.success?
      flash[:notice] = l(:notice_successful_create)
      if params[:continue]
        redirect_to new_project_bx_table_def_column_def_path(@project, @table_def)
      else
        redirect_to project_bx_table_def_path(@project, @table_def)
      end
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

  def up
    @column_def = BxColumnDef.find(params[:id])
    @result = BxTableDefService.new.up_column_def_position!(@column_def)
    if @result.success?
      redirect_to project_bx_table_def_path(@project, @column_def.table_id)
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end

  def down
    @column_def = BxColumnDef.find(params[:id])
    @result = BxTableDefService.new.down_column_def_position!(@column_def)
    if @result.success?
      redirect_to project_bx_table_def_path(@project, @column_def.table_id)
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end
end
