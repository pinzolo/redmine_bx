# coding: utf-8
module BxResourcesHelper
  include BxHelper

  def bx_resource_mark(resource)
    color_class = if resource.values.empty?
                    "bx-resource-values-empty"
                  elsif resource.values.length == resource.branches.length
                    "bx-resource-values-full"
                  else
                    "bx-resource-values-partiality"
                  end
    content_tag(:span, "", :class => ["bx-resource-mark", color_class])
  end
end
