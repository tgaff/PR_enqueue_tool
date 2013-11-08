require 'test_helper'

class PullrequestsControllerTest < ActionController::TestCase
  setup do
    @pullrequest = pullrequests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pullrequests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pullrequest" do
    assert_difference('Pullrequest.count') do
      post :create, pullrequest: { number: @pullrequest.number }
    end

    assert_redirected_to pullrequest_path(assigns(:pullrequest))
  end

  test "should show pullrequest" do
    get :show, id: @pullrequest
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pullrequest
    assert_response :success
  end

  test "should update pullrequest" do
    patch :update, id: @pullrequest, pullrequest: { number: @pullrequest.number }
    assert_redirected_to pullrequest_path(assigns(:pullrequest))
  end

  test "should destroy pullrequest" do
    assert_difference('Pullrequest.count', -1) do
      delete :destroy, id: @pullrequest
    end

    assert_redirected_to pullrequests_path
  end
end
