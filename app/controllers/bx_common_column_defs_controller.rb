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
  end

  def update
  end

  def destroy
  end
end
