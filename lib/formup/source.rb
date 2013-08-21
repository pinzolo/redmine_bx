# coding: utf-8
require "active_support/core_ext/hash/indifferent_access"
require "formup/attr_def"

module Formup
  class Source

    attr_accessor :key, :attribute_defs, :excludes

    def initialize(key, attribute_defs = {}, excludes = nil)
      raise "Formup::Source require key param." if key.nil?

      @key = key.to_s
      @attribute_defs = attribute_defs.map { |k, v| Formup::AttrDef.new(k, v) } if attribute_defs
      @attribute_defs ||= []

      @excludes = excludes ? [excludes].flatten : [:id]
    end

    def base?(base)
      @attribute_defs.any? { |attr_def| attr_def.base == base.to_s }
    end

    def base(attr)
      attr_def = @attribute_defs.detect { |attr_def| attr_def.attr == attr.to_s }
      attr_def ? attr_def.base : nil
    end

    def attr?(attr)
      @attribute_defs.any? { |attr_def| attr_def.attr == attr.to_s }
    end

    def attr(base)
      attr_def = @attribute_defs.detect { |attr_def| attr_def.base == base.to_s }
      attr_def ? attr_def.attr : nil
    end
  end
end
