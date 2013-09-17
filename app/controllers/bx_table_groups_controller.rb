# coding: utf-8
class BxTableGroupsController < ApplicationController
  include BxController
  unloadable

  bx_tab :bx_table_defs

  def show
  end

  def new
    @databases = BxDatabase.all(:include => :data_types, :order => :name)
    @form = BxTableGroupForm.new
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
