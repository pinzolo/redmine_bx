# coding: utf-8
module BxResourcesHelper
  include BxHelper

  def bx_resource_mark(resource)
    not_blank_value_count = resource.values.to_a.count { |value| value.value.present? }
    color_class = if not_blank_value_count.zero?
                    "bx-resource-values-empty"
                  elsif not_blank_value_count == resource.branches.length
                    "bx-resource-values-full"
                  else
                    "bx-resource-values-partiality"
                  end
    content_tag(:span, "", :class => ["bx-resource-mark", color_class])
  end

  def bx_resource_node_text(resource)
    text = resource.code
    text << " : #{resource.summary}" if resource.summary.present?
    text
  end

  def bx_resource_route(resource)
    nodes = resource.ancestry.delete_if { |node| node == resource }
    if nodes.present?
      nodes.map { |node| link_to(node.code, project_bx_resource_path(node.project, node)) }.join("&nbsp;&#187;&nbsp;").html_safe
    else
      "&nbsp;".html_safe
    end
  end
end
