require 'test_helper'

class RemoteWorksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get remote_works_new_url
    assert_response :success
  end

  test "should get index" do
    get remote_works_index_url
    assert_response :success
  end

  test "should get edit" do
    get remote_works_edit_url
    assert_response :success
  end

end
