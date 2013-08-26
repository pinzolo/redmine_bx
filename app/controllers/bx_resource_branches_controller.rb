# coding: utf-8
class BxResourceBranchesController < ApplicationController
  include BxController
  unloadable

  def new
    @form = BxResourceBranchForm.new
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
