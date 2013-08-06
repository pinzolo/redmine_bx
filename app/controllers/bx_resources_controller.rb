# coding: utf-8
class BxResourcesController < ApplicationController
  include BxController
  unloadable

  bx_tab :bx_resources

  def index
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

  def new_root
    @form = BxRootResourceForm.new
  end

  def create_root
    @form = BxRootResourceForm.new(params[:form].merge(:project => @project))
    if @form.valid?
      service = BxResourceService.new
      service.create_root(@form)
    end
  end
end
