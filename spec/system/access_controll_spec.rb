require 'rails_helper'

RSpec.describe 'アクセスコントロール', type: :system, js: true do
  before do
    @user = User.create!(email: 'test@sample.com', password: 'f4k3p455w0rd',name: "user_sample")
    @pre_application = @user.pre_applications.create(genre: "財務",item:"経費申請",description:"hogehoge",amount: 100)

    @user1 = User.create(email: 'user1@sample.com', password: "password", password_confirmation: "password",name: "user_sample")
    @pre_application1 = @user1.pre_applications.create(genre: "財務",item:"経費申請",description:"hogehoge",amount: 100)

    @user2 = User.create(email: 'user2@sample.com', password: "password", password_confirmation: "password",name: "user_sample")

    @admin_user = User.create!(email: 'admin@sample.com', password: 'f4k3p455w0rd',name: "user_sample",admin: true)
  end

  describe '未ログインユーザーのアクセス権限' do
    it '未ログインでもrootにアクセスできること' do
      visit root_path
      expect(page).to have_current_path root_path
    end

    context '申請' do
      it '申請作成ページにアクセスできないこと' do
        visit new_pre_application_path
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

      it '申請一覧ページにアクセスできないこと' do
        visit pre_applications_path
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

      it '申請詳細ページにアクセスできないこと' do
        visit pre_application_path(@pre_application.id)
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

      it '申請編集ページにアクセスできないこと' do
        visit edit_pre_application_path(@pre_application.id)
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end

    context 'approval' do
      it '承認待ち一覧ページにアクセスできないこと' do
        visit approvals_path
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end

    context 'フルリモート' do
      it 'フルリモート申請ページにアクセスできないこと' do
        visit new_remote_work_path
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

      it 'フルリモート申請一覧ページにアクセスできないこと' do
        visit remote_works_path
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end

    context 'アドミン用ユーザー' do
      it 'アドミン用ユーザー一覧ページにアクセスできないこと' do
        visit admin_users_path
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

      it 'アドミン用ユーザー作成ページにアクセスできないこと' do
        visit new_admin_user_path
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

      it 'アドミン用ユーザー詳細ページにアクセスできないこと' do
        visit admin_user_path(@user.id)
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

      it 'アドミン用ユーザー編集ページにアクセスできないこと' do
        visit edit_admin_user_path(@user.id)
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end

    context 'アドミン用申請' do
      it 'アドミン用申請一覧ページにアクセスできないこと' do
        visit admin_pre_applications_path
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

      it 'アドミン用申請詳細ページにアクセスできないこと' do
        visit admin_pre_application_path(@pre_application.id)
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

      it 'アドミン用申請編集ページにアクセスできないこと' do
        visit edit_admin_pre_application_path(@pre_application.id)
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end
  end

  describe 'ログインユーザーの機能' do
    before do
      login_as(@user, :scope => :user)
    end

    context 'ログアウト機能' do
      it 'ログアウトできる' do
        visit root_path
        click_on "ログアウト"
        expect(page).to have_content "Signed out successfully."
        expect(page).to have_current_path root_path
      end
    end

    context '申請' do
      it '申請作成ページにアクセスできること' do
        visit new_pre_application_path
        expect(page).to have_current_path new_pre_application_path
      end

      it '申請一覧ページにアクセスできること' do
        visit pre_applications_path
        expect(page).to have_current_path pre_applications_path
        expect(page).to have_content "#{@pre_application.description}"
      end

      it '申請詳細ページにアクセスできること' do
        visit pre_application_path(@pre_application.id)
        expect(page).to have_current_path pre_application_path(@pre_application.id)
        expect(page).to have_content "#{@pre_application.description}"
      end

      it '他ユーザーの申請詳細ページにアクセスできないこと' do
        visit pre_application_path(@pre_application1.id)
        expect(page).to have_current_path pre_applications_path
      end

      it '申請編集ページにアクセスできること' do
        visit edit_pre_application_path(@pre_application.id)
        expect(page).to have_current_path edit_pre_application_path(@pre_application.id)
        expect(page).to have_content "#{@pre_application.description}"
      end

      it '他ユーザーの申請編集ページにアクセスできないこと' do
        visit edit_pre_application_path(@pre_application1.id)
        expect(page).to have_current_path pre_applications_path
      end
    end

    context 'approval' do
      it '承認待ち一覧ページにアクセスできること' do
        visit approvals_path
        expect(page).to have_current_path approvals_path
      end
    end

    context 'フルリモート' do
      it 'フルリモート申請ページにアクセスできること' do
        visit new_remote_work_path
        expect(page).to have_current_path new_remote_work_path
      end

      it 'フルリモート申請一覧ページにアクセスできること' do
        visit remote_works_path
        expect(page).to have_current_path remote_works_path
      end
    end

    context 'アドミン用ユーザー' do
      it 'アドミン用ユーザー一覧ページにアクセスできないこと' do
        visit admin_users_path
        expect(page).to have_current_path root_path
        expect(page).to have_content 'No Access Right.'
      end

      it 'アドミン用ユーザー作成ページにアクセスできないこと' do
        visit new_admin_user_path
        expect(page).to have_current_path root_path
        expect(page).to have_content 'No Access Right.'
      end

      it 'アドミン用ユーザー詳細ページにアクセスできないこと' do
        visit admin_user_path(@user1.id)
        expect(page).to have_current_path root_path
        expect(page).to have_content 'No Access Right.'
      end

      it 'アドミン用ユーザー編集ページにアクセスできないこと' do
        visit edit_admin_user_path(@user1.id)
        expect(page).to have_current_path root_path
        expect(page).to have_content 'No Access Right.'
      end
    end

    context 'アドミン用申請' do
      it 'アドミン用申請一覧ページにアクセスできないこと' do
        visit admin_pre_applications_path
        expect(page).to have_current_path root_path
        expect(page).to have_content 'No Access Right.'
      end

      it 'アドミン用申請詳細ページにアクセスできないこと' do
        visit admin_pre_application_path(@pre_application1.id)
        expect(page).to have_current_path root_path
        expect(page).to have_content 'No Access Right.'
      end

      it 'アドミン用申請編集ページにアクセスできないこと',type: :doing do
        visit edit_admin_pre_application_path(@pre_application1.id)
        expect(page).to have_current_path root_path
        expect(page).to have_content 'No Access Right.'
      end
    end
  end

  describe 'アドミンユーザーの機能' do
    before do
      login_as(@admin_user, :scope => :user)
    end

    context 'アドミン用ユーザー' do
      it 'アドミン用ユーザー一覧ページにアクセスできること' do
        visit admin_users_path
        expect(page).to have_current_path admin_users_path
      end

      it 'アドミン用ユーザー作成ページにアクセスできること' do
        visit new_admin_user_path
        expect(page).to have_current_path new_admin_user_path
      end

      it 'アドミン用ユーザー詳細ページにアクセスできること' do
        visit admin_user_path(@user1.id)
        expect(page).to have_current_path admin_user_path(@user1.id)
      end

      it 'アドミン用ユーザー編集ページにアクセスできること' do
        visit edit_admin_user_path(@user1.id)
        expect(page).to have_current_path edit_admin_user_path(@user1.id)
      end
    end

    context 'アドミン用申請' do
      it 'アドミン用申請一覧ページにアクセスできること' do
        visit admin_pre_applications_path
        expect(page).to have_current_path admin_pre_applications_path
      end

      it 'アドミン用申請詳細ページにアクセスできること' do
        visit admin_pre_application_path(@pre_application1.id)
        expect(page).to have_current_path admin_pre_application_path(@pre_application1.id)
      end

      it 'アドミン用申請編集ページにアクセスできること' do
        visit edit_admin_pre_application_path(@pre_application1.id)
        expect(page).to have_current_path edit_admin_pre_application_path(@pre_application1.id)
      end
    end
  end
end
