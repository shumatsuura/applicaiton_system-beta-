require 'test_helper'

class PreApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pre_application = pre_applications(:one)
  end

  test "should get index" do
    get pre_applications_url
    assert_response :success
  end

  test "should get new" do
    get new_pre_application_url
    assert_response :success
  end

  test "should create pre_application" do
    assert_difference('PreApplication.count') do
      post pre_applications_url, params: { pre_application: { amount: @pre_application.amount, description: @pre_application.description, genre: @pre_application.genre, item: @pre_application.item, user_id: @pre_application.user_id } }
    end

    assert_redirected_to pre_application_url(PreApplication.last)
  end

  test "should show pre_application" do
    get pre_application_url(@pre_application)
    assert_response :success
  end

  test "should get edit" do
    get edit_pre_application_url(@pre_application)
    assert_response :success
  end

  test "should update pre_application" do
    patch pre_application_url(@pre_application), params: { pre_application: { amount: @pre_application.amount, description: @pre_application.description, genre: @pre_application.genre, item: @pre_application.item, user_id: @pre_application.user_id } }
    assert_redirected_to pre_application_url(@pre_application)
  end

  test "should destroy pre_application" do
    assert_difference('PreApplication.count', -1) do
      delete pre_application_url(@pre_application)
    end

    assert_redirected_to pre_applications_url
  end
end
