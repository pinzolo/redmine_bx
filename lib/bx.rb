# coding: utf-8
module Bx
  def self.rendering_tree=(flag)
    Thread.current[:bx_rendering_tree] = flag
  end

  def self.rendering_tree
    Thread.current[:bx_rendering_tree]
  end
end
