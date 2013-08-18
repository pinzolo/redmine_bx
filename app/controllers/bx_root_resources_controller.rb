# coding: utf-8
class BxRootResourcesController < ApplicationController
  include BxController
  unloadable

  bx_tab :bx_resources

  def show
  end

  def new
    @form = BxRootResourceForm.new
  end

  def create
    @form = BxRootResourceForm.new(params[:form].merge(:project => @project))
    @result = BxResourceService.new(@form).create_root!
  end

  def edit
  end

  def update
  end
end
