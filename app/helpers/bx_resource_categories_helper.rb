# coding: utf-8
module BxResourceCategoriesHelper
  include BxHelper

  def bx_history_details_link(history)
    return "" if history.operation_type == "delete"

    " (#{content_tag(:a, l("bx.label.history.details"), :href => "#", :class => "bx_history_details_link")})".html_safe
  end
end
