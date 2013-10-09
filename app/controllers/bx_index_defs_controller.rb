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
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
