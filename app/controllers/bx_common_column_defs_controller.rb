# coding: utf-8
class BxCommonColumnDefsController < ApplicationController
  include BxController
  unloadable

  bx_tab :bx_table_defs

  def new
    @table_group = BxTableGroup.find(params[:table_group_id])
    @form = BxCommonColumnDefForm.new(:table_group_id => @table_group.id)
  end

  def create
    @table_group = BxTableGroup.find(params[:table_group_id])
    @form = BxCommonColumnDefForm.new(params[:form].merge(:table_group_id => @table_group.id))
    @result = BxTableDefService.new(@form).create_common_column_def!
    if @result.success?
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_bx_table_group_path(@project, @table_group)
    elsif @result.invalid_input?
      render :action => :new
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end

  def edit
    @common_column_def = BxCommonColumnDef.find(params[:id])
    @form = BxCommonColumnDefForm.new(:table_group_id => @common_column_def.table_group_id)
    @form.load(:common_column_def => @common_column_def)
  end

  def update
    @common_column_def = BxCommonColumnDef.find(params[:id])
    @form = BxCommonColumnDefForm.new(params[:form].merge(:table_group_id => @common_column_def.table_group_id, :base_common_column_def => @common_column_def))
    @result = BxTableDefService.new(@form).update_common_column_def!(@common_column_def)
    if @result.success?
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_bx_table_group_path(@project, @common_column_def.table_group_id)
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
    @common_column_def = BxCommonColumnDef.find(params[:id])
    BxTableDefService.new.delete_common_column_def!(@common_column_def)
    flash[:notice] = l(:notice_successful_delete)
    redirect_to project_bx_table_group_path(@project, @common_column_def.table_group_id)
  end

  def up
    @common_column_def = BxCommonColumnDef.find(params[:id])
    @result = BxTableDefService.new.up_common_column_def_position!(@common_column_def)
    if @result.success?
      redirect_to project_bx_table_group_path(@project, @common_column_def.table_group)
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end

  def down
    @common_column_def = BxCommonColumnDef.find(params[:id])
    @result = BxTableDefService.new.down_common_column_def_position!(@common_column_def)
    if @result.success?
      redirect_to project_bx_table_group_path(@project, @common_column_def.table_group)
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end
end
