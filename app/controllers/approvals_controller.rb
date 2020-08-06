class ApprovalsController < ApplicationController
  before_action :set_approval, only:[:update]

  def index
    @approvals = Approval.where(user_id: current_user.id)
  end

  def update
    if @approval.update(approval_params)
      redirect_to approvals_path
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

end
