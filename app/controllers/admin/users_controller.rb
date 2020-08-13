class Admin::UsersController < ApplicationController
  before_action :set_user, only:[:show, :edit, :update, :destroy]
  before_action :ensure_admin_user

  PER = 30
  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(updated_at: "DESC").page(params[:page]).per(PER)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    redirect_to admin_users_path, notice: 'Created new user successfully.'
  end

  def show
  end

  def edit
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete("password")
    end

    if @user.update(user_params)
      redirect_to admin_user_path(@user.id), notice: 'Updated user account successfully.'
    else
      render 'edit'
    end
  end

  def destroy
    if admin_user?
      @user.destroy
      redirect_to admin_users_path, notice: "Deleted user successfully."
    else
      redirect_to root_path, notice: "No Access Right."
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :name,
      :department,
      :team,
      :office,
      :slack_member_id,
      :admin,
    )
  end

  def set_user
    @user = User.find_by(id: params[:id])
  end
end
