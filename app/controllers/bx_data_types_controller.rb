# coding: utf-8
class BxDataTypesController < ApplicationController
  include BxAdminController
  unloadable
  before_filter :find_database, :require_admin

  def new
    @form = BxDataTypeForm.new(:database_id => params[:database_id])
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
  end

  def update
  end

  def destroy
  end

  private
  def find_database
    @database = BxDatabase.find(params[:database_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
