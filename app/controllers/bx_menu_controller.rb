# coding: utf-8
class BxMenuController < ApplicationController
  include BxController
  unloadable

  def index
    render "bx_resources/index"
  end
end
