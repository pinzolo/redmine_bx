# coding: utf-8
module BxResourceCategoriesHelper
  include BxHelper

  def bx_history_details_note(history, detail)
    prop = l("bx.label.history_detail.properties.#{history.operation}.#{detail.property}")
    l("bx.text.history_detail_notes.#{history.operation_type}", :property => prop, :new_value => detail.new_value, :old_value => detail.old_value).html_safe
  end
end
