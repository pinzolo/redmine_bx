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
