# coding: utf-8
class BxColumnDefsController < ApplicationController
  include BxController
  unloadable

  def new
  end

  def create
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
      redirect_to project_bx_table_def_path(@project, @column_def.table_def)
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end

  def down
    @column_def = BxColumnDef.find(params[:id])
    @result = BxTableDefService.new.down_column_def_position!(@column_def)
    if @result.success?
      redirect_to project_bx_table_def_path(@project, @column_def.table_def)
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end
end
