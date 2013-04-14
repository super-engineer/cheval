require 'test_helper'

class PressLinksControllerTest < ActionController::TestCase
  setup do
    @press_link = press_links(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:press_links)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create press_link" do
    assert_difference('PressLink.count') do
      post :create, press_link: { description: @press_link.description, url: @press_link.url }
    end

    assert_redirected_to press_link_path(assigns(:press_link))
  end

  test "should show press_link" do
    get :show, id: @press_link
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @press_link
    assert_response :success
  end

  test "should update press_link" do
    put :update, id: @press_link, press_link: { description: @press_link.description, url: @press_link.url }
    assert_redirected_to press_link_path(assigns(:press_link))
  end

  test "should destroy press_link" do
    assert_difference('PressLink.count', -1) do
      delete :destroy, id: @press_link
    end

    assert_redirected_to press_links_path
  end
end
