# coding: utf-8
module BxAdminController
  extend ActiveSupport::Concern

  included do
    layout 'admin'
  end
end
