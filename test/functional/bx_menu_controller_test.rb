# coding: utf-8
require File.expand_path('../../test_helper', __FILE__)

class BxMenuControllerTest < ActionController::TestCase
  fixtures :projects, :members, :users, :member_roles, :roles
  # Replace this with your real tests.
  test "#index" do
    @request.session[:user_id] = 1
    prj = Project.all.first
    prj.enable_module! :bx
    get :index, :project_id => prj
    assert_response :success
    assert_template :index
    # bx tab is shown and selected
    assert_select "div#main-menu a[class~=bx][class~=selected]"
  end
end
