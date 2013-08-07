# coding: utf-8
Redmine::Plugin.register :redmine_bx do
  name 'redmine_bx'
  author 'pinzolo'
  description 'redmine_bx is a plugin for Redmine. This will reduce excel files in your projects.'
  version '0.0.1'
  url 'https://github.com/pinzolo/redmine_bx'
  author_url 'https://github.com/pinzolo'

  project_module :bx do
    permission :bx_view_menu, :bx_menu => :index
    permission :bx_view_resources, :bx_resources => [:index, :show]
    permission :bx_manage_resources, :bx_resources => [:new, :edit, :create, :update, :destroy, :new_root, :edit_root, :create_root, :update_root], :require => :member
  end

  menu :project_menu, :bx, { :controller => :bx_menu, :action => :index }, :param => :project_id

  Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), "app", "{forms,services}"))) do |dir|
    ActiveSupport::Dependencies.autoload_paths += [dir]
  end
end
