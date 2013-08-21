# coding: utf-8
module Formup
  class AttrDef
    attr_reader :base, :attr

    def initialize(base, attr)
      @base = base.to_s if base
      @attr = attr.to_s if attr
    end
  end
end
