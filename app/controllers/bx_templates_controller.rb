# coding: utf-8
class BxTemplatesController < ApplicationController
  include BxController
  unloadable

  bx_tab :bx_table_defs

  before_filter :validate_target, :only => [:index, :new]

  def index
  end

  def show
  end

  def new
    @form = BxTemplateForm.new(:target => @target)
    # TODO: set back_url by target
    @back_url = "javascript:history.back();"
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def validate_target
    @target = params[:target]
    if @target.blank?
      render_error(l("bx.text.error.template_target_not_found"))
    elsif !BxTemplate.available_target?(@target)
      render_error(l("bx.text.error.invalid_template_target", :target => @target))
    end
  end
end
