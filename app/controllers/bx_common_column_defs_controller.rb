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
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
