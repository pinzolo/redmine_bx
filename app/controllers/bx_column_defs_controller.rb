# coding: utf-8
class BxColumnDefsController < ApplicationController
  include BxController
  unloadable

  bx_tab :bx_table_defs

  def new
    @table_defs = BxTableDef.where(:project_id => @project.id).order(:physical_name)
    @table_def = BxTableDef.find(params[:table_def_id])
    @form = BxColumnDefForm.new(:table_def_id => @table_def.id)
  end

  def create
    @table_defs = BxTableDef.where(:project_id => @project.id).order(:physical_name)
    @table_def = BxTableDef.find(params[:table_def_id])
    @form = BxColumnDefForm.new(params[:form].merge(:table_group_id => @table_def.table_group_id, :table_def_id => @table_def.id))
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
    @table_defs = BxTableDef.where(:project_id => @project.id).order(:physical_name)
    @column_def = BxColumnDef.find(params[:id])
    @form = BxColumnDefForm.new(:reference_table_def_id => @column_def.reference_column_def.try(:table_def_id))
    @form.load(:column_def => @column_def)
  end

  def update
    @column_def = BxColumnDef.find(params[:id])
    merged_params = params[:form].merge(:table_def_id => @column_def.table_def_id,
                                        :table_group_id => @column_def.table_def.table_group_id,
                                        :base_column_def => @column_def)
    @form = BxColumnDefForm.new(merged_params)
    @result = BxTableDefService.new(@form).update_column_def!(@column_def)
    if @result.success?
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_bx_table_def_path(@project, @column_def.table_def_id)
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
    @column_def = BxColumnDef.find(params[:id])
    @result = BxTableDefService.new.delete_column_def!(@column_def)
    if @result.success?
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = @result.data.message
    end
    redirect_to project_bx_table_def_path(@project, @column_def.table_def_id)
  end

  def up
    @column_def = BxColumnDef.find(params[:id])
    @result = BxTableDefService.new.up_column_def_position!(@column_def)
    if @result.success?
      redirect_to project_bx_table_def_path(@project, @column_def.table_def_id)
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end

  def down
    @column_def = BxColumnDef.find(params[:id])
    @result = BxTableDefService.new.down_column_def_position!(@column_def)
    if @result.success?
      redirect_to project_bx_table_def_path(@project, @column_def.table_def_id)
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end
end
