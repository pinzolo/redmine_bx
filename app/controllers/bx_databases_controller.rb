# coding: utf-8
class BxDatabasesController < ApplicationController
  include BxAdminController
  unloadable

  def index
    @databases = BxDatabase.all(:order => :name)
  end

  def new
    @form = BxDatabaseForm.new
    @databases = BxDatabase.all(:order => :name)
  end
end
