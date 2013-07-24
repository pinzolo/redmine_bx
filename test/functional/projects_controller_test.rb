# coding: utf-8
require File.expand_path('../../test_helper', __FILE__)

class ProjectsControllerTest < ActionController::TestCase
  fixtures :projects, :users

  test "show bx tab on enabled project and logged in" do
    @request.session[:user_id] = 1
    prj = Project.all.first
    prj.enable_module! :bx

    get :show, :id => prj
    assert_select 'div#main-menu a.bx'
  end

  test "not show bx tab on disabled project and logged in" do
    @request.session[:user_id] = 1
    prj = Project.all.first

    get :show, :id => prj
    assert_select 'div#main-menu a.bx', false
  end

  test "not show bx tab on enabled project and not logged in" do
    @request.session[:user_id] = nil
    prj = Project.all.first
    prj.enable_module! :bx

    get :show, :id => prj
    assert_select 'div#main-menu a.bx', false
  end
end

