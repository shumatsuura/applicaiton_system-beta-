require "application_system_test_case"

class PreApplicationsTest < ApplicationSystemTestCase
  setup do
    @pre_application = pre_applications(:one)
  end

  test "visiting the index" do
    visit pre_applications_url
    assert_selector "h1", text: "Pre Applications"
  end

  test "creating a Pre application" do
    visit pre_applications_url
    click_on "New Pre Application"

    fill_in "Amount", with: @pre_application.amount
    fill_in "Description", with: @pre_application.description
    fill_in "Genre", with: @pre_application.genre
    fill_in "Item", with: @pre_application.item
    fill_in "User", with: @pre_application.user_id
    click_on "Create Pre application"

    assert_text "Pre application was successfully created"
    click_on "Back"
  end

  test "updating a Pre application" do
    visit pre_applications_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @pre_application.amount
    fill_in "Description", with: @pre_application.description
    fill_in "Genre", with: @pre_application.genre
    fill_in "Item", with: @pre_application.item
    fill_in "User", with: @pre_application.user_id
    click_on "Update Pre application"

    assert_text "Pre application was successfully updated"
    click_on "Back"
  end

  test "destroying a Pre application" do
    visit pre_applications_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Pre application was successfully destroyed"
  end
end
