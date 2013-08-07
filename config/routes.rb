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
      collection do
        get :new_root
        post :create_root
        get :edit_root
        put :update_root
      end
    end
  end
end
