class ApprovalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_approval, only:[:update]
  before_action :authenticate_approver, only:[:update]

  def index
    # @approvals = Approval.all
    @approvals = Approval.where(user_id: current_user.id)
  end

  def update
    if @approval.update(approval_params)
      redirect_to approvals_path, notice: "承認しました。"
    else
      render 'index'
    end
  end

  private

  def set_approval
    @approval = Approval.find_by(id: params[:id])
  end

  def approval_params
    params.require(:approval).permit(:judge)
  end

  def authenticate_approver
    if current_user == @approval.user
    else
      redirect_to approvals_path, notice: "権限がありません。"
    end
  end

end
