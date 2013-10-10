# coding: utf-8
class BxIndexDefsController < ApplicationController
  include BxController
  unloadable

  bx_tab :bx_table_defs

  def new
    @table_def = BxTableDef.find(params[:table_def_id])
    @form = BxIndexDefForm.new(:table_def_id => @table_def.id)
  end

  def create
    @table_def = BxTableDef.find(params[:table_def_id])
    @form = BxIndexDefForm.new(params[:form].merge(:table_def_id => @table_def.id))
    @result = BxTableDefService.new(@form).create_index_def!
    if @result.success?
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_bx_table_def_path(@project, @table_def)
    elsif @result.invalid_input?
      render :action => :new
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end

  def edit
    @index_def = BxIndexDef.find(params[:id])
    positions = {}.tap do |h|
      @index_def.columns_rels.each do |rel|
        h[rel.column_def_id] = rel.position
      end
    end
    @form = BxIndexDefForm.new(:table_def_id => @index_def.table_def_id, :positions => positions)
    @form.load(:index_def => @index_def)
  end

  def update
    @index_def = BxIndexDef.find(params[:id])
    merged_params = params[:form].merge(:table_def_id => @index_def.table_def_id,
                                        :base_index_def => @index_def)
    @form = BxIndexDefForm.new(merged_params)
    @result = BxTableDefService.new(@form).update_index_def!(@index_def)
    if @result.success?
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_bx_table_def_path(@project, @index_def.table_def_id)
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
    @index_def = BxIndexDef.find(params[:id])
    @result = BxTableDefService.new.delete_index_def!(@index_def)
    if @result.success?
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = @result.data.message
    end
    redirect_to project_bx_table_def_path(@project, @index_def.table_def_id)
  end
end
