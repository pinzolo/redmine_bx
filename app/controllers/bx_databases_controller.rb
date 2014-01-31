# coding: utf-8
class BxDatabasesController < ApplicationController
  include BxAdminController
  unloadable

  def index
    find_databases
  end

  def show
    @database = BxDatabase.find(params[:id])
  end

  def new
    find_databases
    @form = BxDatabaseForm.new
  end

  def create
    @form = BxDatabaseForm.new(params[:form])
    @result = BxAdminService.new(@form).create_database!
    if @result.success?
      flash[:notice] = l(:notice_successful_create)
      redirect_to bx_database_path(@result.data)
    elsif @result.invalid_input?
      find_databases
      render :action => :new
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end

  def edit
    @database = BxDatabase.find(params[:id])
    @form = BxDatabaseForm.new
    @form.load(:database => @database)
  end

  def update
    @database = BxDatabase.find(params[:id])
    @form = BxDatabaseForm.new(params[:form])
    @result = BxAdminService.new(@form).update_database!(@database)
    if @result.success?
      flash[:notice] = l(:notice_successful_update)
      redirect_to bx_database_path(@database)
    elsif @result.invalid_input?
      find_databases
      render :action => :edit
    elsif @result.conflict?
      find_databases
      flash.now[:error] = l(:notice_locking_conflict)
      render :action => :edit
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end

  def destroy
    @database = BxDatabase.find(params[:id])
    @result = BxAdminService.new.delete_database!(@database)
    if @result.success?
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = @result.data.message
    end
    redirect_to bx_databases_path
  end

  private
  def find_databases
    @databases = BxDatabase.all(:include => :data_types, :order => :name)
  end
end
