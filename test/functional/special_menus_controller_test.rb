require 'test_helper'

class SpecialMenusControllerTest < ActionController::TestCase
  setup do
    @special_menu = special_menus(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:special_menus)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create special_menu" do
    assert_difference('SpecialMenu.count') do
      post :create, special_menu: { description: @special_menu.description, name: @special_menu.name }
    end

    assert_redirected_to special_menu_path(assigns(:special_menu))
  end

  test "should show special_menu" do
    get :show, id: @special_menu
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @special_menu
    assert_response :success
  end

  test "should update special_menu" do
    put :update, id: @special_menu, special_menu: { description: @special_menu.description, name: @special_menu.name }
    assert_redirected_to special_menu_path(assigns(:special_menu))
  end

  test "should destroy special_menu" do
    assert_difference('SpecialMenu.count', -1) do
      delete :destroy, id: @special_menu
    end

    assert_redirected_to special_menus_path
  end
end
