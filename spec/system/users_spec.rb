require 'rails_helper'

RSpec.describe 'ユーザー機能', type: :system, js: true do
  before do
    @user1 = User.create(email: 'user1@sample.com', password: "password", password_confirmation: "password")
    @user2 = User.create(email: 'user2@sample.com', password: "password", password_confirmation: "password")
  end

  describe '未ログインユーザーのアクセス権限' do

    it '未ログインではユーザーダッシュボードページにアクセスできないこと' do
      visit root_path
      expect(page).to have_current_path root_path
    end

    it '未ログインでは申請画面にアクセスできないこと' do
      visit new_pre_application_path
      expect(page).to have_current_path new_user_session_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    it '未ログインではユーザーインデックスにアクセスできないこと' do
      visit users_path
      expect(page).to have_current_path new_company_session_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  # describe 'ログインユーザーの機能' do
  #   before do
  #     @user = User.create!(:email => 'test@example.com', :password => 'f4k3p455w0rd')
  #     login_as(@user, :scope => :user)
  #   end
  #
  #   context 'ログアウト機能' do
  #     it 'ログアウトできる' do
  #       visit dashboard_user_path(@user)
  #       all(".fa-bars")[0].click
  #       click_on "Log-out"
  #       expect(page).to have_content "Signed out successfully."
  #       expect(page).to have_current_path root_path
  #     end
  #   end
  #
  #   context 'アクセス権限' do
  #     it '自分のユーザー詳細ページにアクセスできること' do
  #       visit user_path(@user.id)
  #       expect(page).to have_current_path user_path(@user.id)
  #     end
  #
  #     it '他ユーザーの詳細ページにアクセスできないこと' do
  #       visit user_path(@user1.id)
  #       expect(page).to have_current_path root_path
  #       expect(page).to have_content "No Access Right."
  #     end
  #
  #     it 'ユーザーインデックスページにアクセスできないこと' do
  #       visit users_path
  #       expect(page).to have_current_path new_company_session_path
  #     end
  #
  #     it '自分のダッシュボードにアクセスできること' do
  #       visit dashboard_user_path(@user.id)
  #       expect(page).to have_current_path dashboard_user_path(@user.id)
  #       expect(page).to have_content @user.email
  #     end
  #
  #     it '他ユーザーのダッシュボードにアクセスできないこと' do
  #       visit dashboard_user_path(@user1.id)
  #       expect(page).to have_current_path root_path
  #       expect(page).to have_content "No Access Right."
  #     end
  #
  #     it '自分の詳細ページから基本情報を編集できること' do
  #       visit user_path(@user.id)
  #       click_on 'Edit Profile'
  #
  #       fill_in 'user_first_name', with:'test'
  #       fill_in 'user_last_name', with:'test'
  #       select 'Male', from:'user_gender'
  #       select '1986', from: 'user_date_of_birth_1i'
  #       select 'November', from: 'user_date_of_birth_2i'
  #       select '2', from: 'user_date_of_birth_3i'
  #       select 'Closed', from:'user_status'
  #       click_on 'Update User'
  #       expect(page).to have_content 'successfully'
  #     end
  #
  #     it '自分の詳細ページからJob Categoryを編集できること' do
  #       JobCategory.create(name: "test_category")
  #       Industry.create(name: "test_industry")
  #
  #       visit user_path(@user.id)
  #       click_on 'edit_industry'
  #       click_on 'Add Industry Field'
  #
  #       find('.industries').all('option')[1].select_option
  #
  #       click_on 'Update User'
  #       expect(page).to have_content 'successfully'
  #     end
  #
  #     it '自分のアカウントを編集できること' do
  #       visit edit_user_registration_path(@user.id)
  #       expect(page).to have_current_path edit_user_registration_path(@user.id)
  #
  #       fill_in 'Email', with: 'user1-b@sample.com'
  #       fill_in 'Password', with: "passwordo"
  #       fill_in 'Password confirmation', with: "passwordo"
  #       fill_in 'Current password', with: "f4k3p455w0rd"
  #
  #       click_on 'Update'
  #       expect(page).to have_content 'successfully'
  #     end
  #
  #     it '他ユーザーのプロフィール編集ページにアクセスできないこと' do
  #       visit edit_user_path(@user1.id)
  #       expect(page).to have_current_path root_path
  #     end
  #
  #     it 'ログイン後ユーザー登録ページにアクセスできない' do
  #       visit new_user_registration_path
  #       expect(page).to have_current_path root_path
  #       expect(page).to have_content "You are already signed in."
  #     end
  #
  #     context '編集' do
  #     end
  #
  #   end
  # end
  #
  # describe 'アドミンユーザーのアクセス権限' do
  #   before do
  #     @admin_user = User.create(email: 'admin_user@sample.com', password: "password", password_confirmation: "password", admin: true, uid: SecureRandom.uuid)
  #     @user3 = User.create(email: 'user3@sample.com', password: "password", password_confirmation: "password", uid: SecureRandom.uuid)
  #     login_as(@admin_user, :scope => :user)
  #   end
  #
  #   it 'ユーザーを作成できる' do
  #     x = User.all.count
  #     visit admin_users_path
  #     click_on 'Create New User'
  #
  #     fill_in 'Email', with: 'user3@sample.com'
  #     fill_in 'Password', with: "password"
  #     fill_in 'Password confirmation', with: "password"
  #     click_on 'Create User'
  #
  #     expect(page).to have_content "successfully"
  #   end
  #
  #   it 'ユーザー詳細ページにアクセスできる' do
  #     visit user_path(@user1.id)
  #     expect(page).to have_current_path user_path(@user1.id)
  #   end
  #
  #   it 'ユーザーダッシュボードにアクセスできる' do
  #     visit dashboard_user_path(@user1.id)
  #     expect(page).to have_current_path dashboard_user_path(@user1.id)
  #   end
  #
  #   it 'ユーザープロフィール情報を編集できる' do
  #     JobCategory.create(name: "test_category")
  #     Industry.create(name: "test_industry")
  #
  #     visit edit_user_path(@user1.id)
  #     fill_in 'user_first_name', with:'admin'
  #     fill_in 'user_last_name', with:'admin'
  #     select 'Male', from:'user_gender'
  #     select 'Closed', from:'user_status'
  #     select '1986', from: 'user_date_of_birth_1i'
  #     select 'November', from: 'user_date_of_birth_2i'
  #     select '2', from: 'user_date_of_birth_3i'
  #
  #
  #     fill_in 'user_languages_attributes_0_name', with: 'English'
  #     select 'Native', from: 'user_languages_attributes_0_level'
  #
  #     select 'test_category', from: "user_desired_job_categories_attributes_0_job_category_id"
  #     select 'test_industry', from: "user_desired_industries_attributes_0_industry_id"
  #     fill_in 'user_educations_attributes_0_school_name', with: "test_school"
  #     select '1999', from: 'user_educations_attributes_0_period_start_1i'
  #     select 'April', from: 'user_educations_attributes_0_period_start_2i'
  #     fill_in 'user_work_experiences_attributes_0_company', with: "test_company"
  #     select '1999', from: 'user_work_experiences_attributes_0_period_start_1i'
  #     select 'April', from: 'user_work_experiences_attributes_0_period_start_2i'
  #
  #     select '1999', from: 'user_qualifications_attributes_0_date_of_acquisition_1i'
  #     select 'April', from: 'user_qualifications_attributes_0_date_of_acquisition_2i'
  #
  #     fill_in 'user_qualifications_attributes_0_name', with: 'test_qualification'
  #
  #     fill_in 'user_user_skills_attributes_0_name', with: 'test_skill'
  #
  #     click_on 'Update User'
  #
  #     expect(page).to have_content 'successfully'
  #   end
  #
  #   it 'ユーザーアカウント情報を編集できる' do
  #     visit admin_users_path
  #     click_on 'Edit', match: :first
  #     click_on 'Edit Account'
  #     fill_in 'Email', with: 'user1-b@sample.com'
  #     fill_in 'Password', with: "passwordo"
  #     click_on 'Update'
  #     expect(page).to have_content 'user1-b@sample.com'
  #     expect(page).to have_content 'successfully'
  #   end
  #
  #   it 'ユーザーを削除できる' do
  #     visit admin_users_path
  #     x = User.all.count
  #
  #     click_on 'Edit', match: :first
  #     accept_alert do
  #       click_link 'Delete'
  #     end
  #
  #     sleep 2
  #     y = User.all.count
  #     expect(x-y).to eq 1
  #   end
  # end
end
