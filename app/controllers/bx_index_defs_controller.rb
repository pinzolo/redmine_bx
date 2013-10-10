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
  end

  def update
  end

  def destroy
  end
end
