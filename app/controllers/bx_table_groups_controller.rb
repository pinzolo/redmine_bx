# coding: utf-8
class BxTableGroupsController < ApplicationController
  include BxController
  unloadable

  bx_tab :bx_table_defs

  def show
    @table_group = BxTableGroup.find(params[:id])
  end

  def new
    @databases = BxDatabase.all(:include => :data_types, :order => :name)
    @form = BxTableGroupForm.new
    @databases.each do |db|
      db.data_types.each do |data_type|
        @form.data_types << data_type.id if data_type.default_use?
      end
    end
  end

  def create
    @form = BxTableGroupForm.new(params[:form].merge(:project_id => @project.id))
    @result = BxTableDefService.new(@form).create_table_group!
    if @result.success?
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_bx_table_group_path(@project, @result.data)
    elsif @result.invalid_input?
      @databases = BxDatabase.all(:include => :data_types, :order => :name)
      render :action => :new
    elsif @result.error?
      render_error(:message => @result.data.message)
    end
  end

  def edit
    @databases = BxDatabase.all(:include => :data_types, :order => :name)
    @table_group = BxTableGroup.find(params[:id])
    @form = BxTableGroupForm.new(:data_types => @table_group.data_types.map(&:id))
    @form.load(:table_group => @table_group)
  end

  def update
    @databases = BxDatabase.all(:include => :data_types, :order => :name)
    @table_group = BxTableGroup.find(params[:id])
    @form = BxTableGroupForm.new(params[:form].merge(:project_id => @project.id))
    @result = BxTableDefService.new(@form).update_table_group!(@table_group)
    if @result.success?
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_bx_table_group_path(@project, @table_group)
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
    @table_group = BxTableGroup.find(params[:id])
    @result = BxTableDefService.new.delete_table_group!(@table_group)
    if @result.success?
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = @result.data.message
    end
    redirect_to project_bx_table_defs_path(@project)
  end
end
