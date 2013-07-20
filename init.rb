# coding: utf-8
Redmine::Plugin.register :redmine_bx do
  name 'redmine_bx'
  author 'pinzolo'
  description 'redmine_bx is a plugin for Redmine. This will reduce excel files in your projects.'
  version '0.0.1'
  url 'https://github.com/pinzolo/redmine_bx'
  author_url 'https://github.com/pinzolo'

  project_module :bx do
    permission :view_menu, :bx_menu => :index
    permission :view_resources, :bx_resources => [:index, :show]
    permission :manage_resources, :bx_resources => [:new, :edit, :create, :update, :destroy], :require => :member
  end

  menu :project_menu, :bx, { :controller => :bx_menu, :action => :index }, :param => :project_id
end
