# coding: utf-8
class BxDatabasesController < ApplicationController
  include BxAdminController
  unloadable

  def index
    @databases = BxDatabase.all(:order => :name)
  end

  def show
    @database = BxDatabase.find(params[:id])
  end

  def new
    @form = BxDatabaseForm.new
    @databases = BxDatabase.all(:order => :name)
  end

  def create
    @form = BxDatabaseForm.new(params[:form])
    @result = BxAdminService.new(@form).create_database!
    if @result.success?
      flash[:notice] = l(:notice_successful_create)
      redirect_to bx_database_path(@result.data)
    elsif @result.invalid_input?
      @databases = BxDatabase.all(:order => :name)
      render :action => :new
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end
end
