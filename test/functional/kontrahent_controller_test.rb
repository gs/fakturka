require 'test_helper'

class KontrahentControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:kontrahent)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_kontrahent
    assert_difference('Kontrahent.count') do
      post :create, :kontrahent => { }
    end

    assert_redirected_to kontrahent_path(assigns(:kontrahent))
  end

  def test_should_show_kontrahent
    get :show, :id => kontrahent(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => kontrahent(:one).id
    assert_response :success
  end

  def test_should_update_kontrahent
    put :update, :id => kontrahent(:one).id, :kontrahent => { }
    assert_redirected_to kontrahent_path(assigns(:kontrahent))
  end

  def test_should_destroy_kontrahent
    assert_difference('Kontrahent.count', -1) do
      delete :destroy, :id => kontrahent(:one).id
    end

    assert_redirected_to kontrahent_path
  end
end
