require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get user_create_url
    assert_response :success
  end

  test "should get update" do
    get user_update_url
    assert_response :success
  end
end
