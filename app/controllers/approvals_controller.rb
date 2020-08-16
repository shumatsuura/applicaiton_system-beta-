class ApprovalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_approval, only:[:update]
  before_action :authenticate_approver, only:[:update]

  def index
    # @approvals = Approval.all
    @approvals = Approval.where(user_id: current_user.id).order(created_at: "DESC")
  end

  def update
    n = 0
    if @approval.update(approval_params)
      #全体ステータス（overall_approvalの更新）
      if @approval.judge == false
        #apprvalをfalseに更新した場合、overall_approvalを却下
        a = @approval.pre_application.overall_approval
        a.status = "否認"
        a.save
      else
        #apprvalをtrueに更新した場合、他のapprovalsのjudgeを確認。
        #他のapprovalsが全てtrueであればn=0
        @approval.pre_application.approvals.each do |approval|
          if approval.judge == false
            n += 1
          elsif approval.judge == nil
            n += 1
          elsif approval.judge == true
            n += 0
          end
        end
        #n=0の場合、overall_approvalを"承認済み"に更新
        if n == 0
          a = @approval.pre_application.overall_approval
          a.status = "承認済"
          a.save
        end
      end

      #Slackへの通知
      notifier = Slack::Notifier.new(
        ENV['WEBHOOK_URL'],
        channel: '#' + ENV['CHANNEL']
      )
      applier = "<@" + @approval.pre_application.user.slack_member_id + ">"

      message = <<~"EOS"
      申請状況が更新されました。
      申請者：#{applier}
      分野：#{@approval.pre_application.genre}
      項目：#{@approval.pre_application.item}
      承認者：#{@approval.user.name}
      承認結果：#{@approval.judge ? "承認" : "否認"}
      全体ステータス：#{@approval.pre_application.overall_approval.status}
      <#{pre_application_url(@approval.pre_application.id)}|詳細>
      EOS
      notifier.ping(message)

      redirect_to approvals_path, notice: "承認しました。" if @approval.judge == true
      redirect_to approvals_path, notice: "否認しました。" if @approval.judge == false
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
