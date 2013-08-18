# coding: utf-8
# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :projects do
    get :bx, :controller => :bx_menu, :action => :index

    resources :resources, :controller => :bx_resources do
      member do
        get :children
      end
    end
    namespace :resources, :module => nil do
      resources :roots, :controller => :bx_root_resources, :only => [:new, :create, :edit, :update]
    end
  end
end
