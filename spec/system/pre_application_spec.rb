require 'rails_helper'

RSpec.describe '事前申請', type: :system, js: true do
  before do
    @user = User.create!(email: 'test@sample.com', password: 'password',name: "user_sample",slack_member_id: "UU5GXJ9MX")
    @pre_application = @user.pre_applications.create(genre: "財務",item:"経費申請",description:"hogehoge",amount: 100)

    @user1 = User.create(email: 'user1@sample.com', password: "password", password_confirmation: "password",name: "user_sample1",slack_member_id: "UU5GXJ9MX")
    @pre_application1 = @user1.pre_applications.create(genre: "財務",item:"経費申請",description:"hogehoge",amount: 100)

    @user2 = User.create(email: 'user2@sample.com', password: "password", password_confirmation: "password",name: "user_sample2",slack_member_id: "UU5GXJ9MX")

    @admin_user = User.create!(email: 'admin@sample.com', password: 'password',name: "user_sample",admin: true,name: "admin_user",slack_member_id: "UU5GXJ9MX")
  end

  describe '一般ユーザー' do
    before do
      login_as(@user, :scope => :user)
    end

    context '新規作成' do
      it '申請作成ページにアクセス' do
        visit root_path
        click_on '新規申請'
        expect(page).to have_current_path new_pre_application_path
      end

      it '申請から承認' do
        visit new_pre_application_path

        select '基本', from: "pre_application_genre"
        select '重要な契約', from: "pre_application_item"
        fill_in 'Description', with:'aaa aaa iii'
        select 'user_sample2', from: "pre_application_approvals_attributes_0_user_id"
        select 'user_sample1', from: "pre_application_reports_attributes_0_user_id"

        click_on '申請'

        expect(page).to have_content 'Pre application was successfully created.'
        expect(page).to have_content '基本'
        expect(page).to have_content '重要な契約'
        expect(page).to have_content 'aaa aaa iii'

        visit pre_applications_path

        expect(page).to have_content '基本'
        expect(page).to have_content '重要な契約'
        expect(page).to have_content 'aaa aaa iii'
        expect(page).to have_content 'user_sample2'

        expect(all(".judge")[0].text).to eq '承認待ち'
        expect(all(".approver")[0].text).to eq 'user_sample2'
        expect(all(".overall_status")[0].text).to eq '承認待ち'

        click_on 'ログアウト'
        click_on 'ログイン'
        fill_in 'Email', with:'user2@sample.com'
        fill_in 'Password', with:'password'
        click_on 'Log in'
        click_on '承認待ち一覧'
        click_on '承認する'

        click_on 'ログアウト'
        click_on 'ログイン'
        fill_in 'Email', with:'test@sample.com'
        fill_in 'Password', with:'password'
        click_on 'Log in'
        click_on '申請一覧'

        expect(all(".judge")[0].text).to eq '承認済'
        expect(all(".approver")[0].text).to eq 'user_sample2'
        expect(all(".overall_status")[0].text).to eq '承認済'

        click_on 'Edit', match: :first
        expect(page).to have_content '既に承認者が操作済みのため編集できません。'

      end

      it '編集' do
        visit new_pre_application_path

        select '基本', from: "pre_application_genre"
        select '重要な契約', from: "pre_application_item"
        fill_in 'Description', with:'aaa aaa iii'
        select 'user_sample2', from: "pre_application_approvals_attributes_0_user_id"
        select 'user_sample1', from: "pre_application_reports_attributes_0_user_id"

        click_on '申請'
        click_on 'Edit'

        select '財務', from: "pre_application_genre"
        select '経費（50万円以上）', from: "pre_application_item"
        click_on '申請'

        expect(page).to have_content '財務'
        expect(page).to have_content '経費（50万円以上）'
      end
    end

    context 'edit' do
    end

    context 'index' do
    end

  end

end
