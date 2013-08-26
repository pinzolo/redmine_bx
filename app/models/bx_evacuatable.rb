# coding: utf-8
module BxEvacuatable
  extend ActiveSupport::Concern

  attr_accessor :evacuated_values

  included do
    before_update :evacuate_values
  end

  module ClassMethods
    attr_accessor :evacuatable_attributes

    def evacuatable(*attributes)
      @evacuatable_attributes = attributes.map(&:to_s)
    end
  end

  def evacuate_values
    attrs = self.class.evacuatable_attributes || []
    self.evacuated_values = {}.with_indifferent_access.tap do |values|
      attrs.each do |attr|
        values[attr] = self.__send__("#{attr}_was")
      end
    end
  end

  def changesets
    values = self.evacuated_values || {}
    @changesets ||= {}.with_indifferent_access.tap do |obj|
      self.class.evacuatable_attributes.each do |attr|
        value = self.__send__(attr) || ""
        old_value = values[attr] || ""
        obj[attr] = [old_value, value] if value != old_value
      end
    end
  end
end
