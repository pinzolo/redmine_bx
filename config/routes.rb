# coding: utf-8
# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :projects do
    get :bx, :controller => :bx_menu, :action => :index

    namespace :bx, :module => nil do
      resources :resources, :controller => :bx_resources, :except => [:new, :create] do
        member do
          get :children
        end
      end
      resources :categories, :controller => :bx_resource_categories, :except => [:index] do
        resources :resources, :controller => :bx_resources, :only => [:new, :create]
        resources :branches, :controller => :bx_resource_branches, :only => [:new, :create]
      end
      resources :branches, :controller => :bx_resource_branches, :only => [:edit, :update, :destroy]
    end
  end
end
