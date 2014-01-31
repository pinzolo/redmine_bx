# coding: utf-8
class BxDataTypesController < ApplicationController
  include BxAdminController
  unloadable
  before_filter :find_database, :require_admin

  def new
    @form = BxDataTypeForm.new(:database_id => @database.id)
  end

  def create
    @form = BxDataTypeForm.new(params[:form].merge(:database_id => @database.id))
    @result = BxAdminService.new(@form).create_data_type!
    if @result.success?
      flash[:notice] = l(:notice_successful_create)
      redirect_to bx_database_path(@database)
    elsif @result.invalid_input?
      render :action => :new
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end

  def edit
    @data_type = BxDataType.find(params[:id])
    @form = BxDataTypeForm.new(:database_id => @database.id)
    @form.load(:data_type => @data_type)
  end

  def update
    @data_type = BxDataType.find(params[:id])
    @form = BxDataTypeForm.new(params[:form].merge(:database_id => @database.id))
    @result = BxAdminService.new(@form).update_data_type!(@data_type)
    if @result.success?
      flash[:notice] = l(:notice_successful_update)
      redirect_to bx_database_path(@database)
    elsif @result.invalid_input?
      render :action => :edit
    elsif @result.conflict?
      flash.now[:error] = l(:notice_locking_conflict)
      render :action => :edit
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end

  def destroy
    @data_type = BxDataType.find(params[:id])
    @result = BxAdminService.new.delete_data_type!(@data_type)
    if @result.success?
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = @result.data.message
    end
    redirect_to bx_database_path(@database)
  end

  private
  def find_database
    @database = BxDatabase.find(params[:database_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
