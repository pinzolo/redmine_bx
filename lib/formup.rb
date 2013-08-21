# coding: utf-8
require "formup/version"
require "formup/source"
require "active_support/concern"
require "active_model/conversion"
require "active_model/validations"
require "active_model/naming"
require "active_model/translation"

module Formup
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Conversion
    include ActiveModel::Validations
    extend ActiveModel::Naming
    extend ActiveModel::Translation
  end

  # Class methods {{{
  module ClassMethods
    def sources
      initialize_sources
      @sources.dup
    end

    def source(key, options={})
      initialize_sources
      attribute_defs = create_attribute_defs(key, options[:attributes], options[:aliases])
      @sources[key] = Formup::Source.new(key, attribute_defs, options[:excludes])
      deploy_attributes(attribute_defs)
    end

    private
    def create_attribute_defs(key, attributes, aliases)
      attribute_defs = {}.with_indifferent_access

      if attributes
        attributes.each do |attr|
          attribute_defs[attr.to_s] = "#{key}_#{attr}"
        end
      end
      if aliases
        aliases.each do |k, v|
          attribute_defs[k.to_s] = v.to_s
        end
      end
      attribute_defs
    end

    def deploy_attributes(defs)
      defs.values.each do |attr|
        attr_accessor attr
      end
    end

    def initialize_sources
      @sources ||= {}.with_indifferent_access
    end
  end
  # }}}

  # Instance methods {{{
  def initialize(params = {})
    return unless params

    parameters = params.dup.with_indifferent_access
    self.class.sources.each do |_, src|
      src.attribute_defs.each do |attr_def|
        __send__(attr_def.attr.to_s + "=", parameters.delete(attr_def.attr)) if parameters.key?(attr_def.attr)
      end
    end
    handle_extra_params(parameters) unless parameters.empty?
  end

  def handle_extra_params(parameters)
  end

  def persisted?
    false
  end

  def params_for(key, full = false)
    parameters = {}.with_indifferent_access
    return parameters unless self.class.sources.key?(key)

    source = self.class.sources[key]
    source.attribute_defs.inject(parameters) do |result, attr_def|
      result[attr_def.base] = __send__(attr_def.attr) if full || source.excludes.all? { |attr| attr.to_s != attr_def.base }
      result
    end
  end

  def load(params = {})
    params.each do |k, v|
      if self.class.sources.key?(k)
        source = self.class.sources[k]
        source.attribute_defs.each do |attr_def|
          value = extract_value(v, attr_def.base)
          __send__(attr_def.attr + "=", value) if value
        end
      end
    end
  end

  private
  def extract_value(obj, attr)
    if obj.respond_to?(attr)
      obj.__send__(attr)
    elsif obj.respond_to?(:[])
      obj[attr.to_s] || obj[attr.to_sym]
    else
      nil
    end
  end
  # }}}
end
