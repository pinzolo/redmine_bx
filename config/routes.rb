# coding: utf-8
# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :projects do
    get :bx, :controller => :bx_resources, :action => :index

    namespace :bx, :module => nil do
      resources :resources, :controller => :bx_resources
      resources :categories, :controller => :bx_resource_categories, :except => [:index] do
        resources :branches, :controller => :bx_resource_branches, :only => [:new, :create]
      end
      resources :branches, :controller => :bx_resource_branches, :only => [:edit, :update, :destroy]

      resources :table_defs, :controller => :bx_table_defs
      resources :table_groups, :controller => :bx_table_groups, :except => [:index] do
        resources :common_column_defs, :controller => :bx_common_column_defs, :only => [:new, :create]
        resources :table_defs, :controller => :bx_table_defs, :only => [:new, :create]
      end
      resources :common_column_defs, :controller => :bx_common_column_defs, :only => [:edit, :update, :destroy] do
        member do
          put :up
          put :down
        end
      end
      resources :table_defs, :controller => :bx_table_defs, :only => [:show, :edit, :update, :destroy] do
        resources :column_defs, :controller => :bx_column_defs, :only => [:new, :create]
        resources :index_defs, :controller => :bx_index_defs, :only => [:new, :create]
      end
      resources :column_defs, :controller => :bx_column_defs, :only => [:edit, :update, :destroy] do
        member do
          put :up
          put :down
        end
      end
      resources :index_defs, :controller => :bx_index_defs, :only => [:edit, :update, :destroy]
    end
    resources :templates, :controller => :bx_templates
  end
end
