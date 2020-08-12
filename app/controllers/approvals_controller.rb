class ApprovalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_approval, only:[:update]
  before_action :authenticate_approver, only:[:update]

  def index
    # @approvals = Approval.all
    @approvals = Approval.where(user_id: current_user.id)
  end

  def update
    n = 0
    if @approval.update(approval_params)
      if @approval.judge == false
        a = @approval.pre_application.overall_approvals.first
        a.status = "承認却下"
        a.save
      else
        @approval.pre_application.approvals.each do |approval|
          if approval.judge == false
            n += 1
          elsif approval.judge == nil
            n += 1
          elsif approval.judge == true
            n += 0
          end
        end
        if n == 0
          a = @approval.pre_application.overall_approvals.first
          a.status = "承認済み"
          a.save
        end
      end
      
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
