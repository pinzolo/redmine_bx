# coding: utf-8
# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :projects do
    # menu
    get :bx, :controller => :bx_menu, :action => :index
  end
end
