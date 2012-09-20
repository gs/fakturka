require 'test_helper'

class FakturkaControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_should_check_index
    login_as(:admin)
    post :index
    assert_template 'list'
  end
end

