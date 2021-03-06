class PreApplicationsController < ApplicationController
  before_action :set_pre_application, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!,only: [:new,:create,:index,:show,:edit,:update,:destroy]
  before_action :authenticate_editer, only: [:edit, :update, :destroy]
  before_action :authenticate_viewer, only: [:show]

  PER = 10

  def index
    @q = PreApplication.where(user_id: current_user.id).order(updated_at: "DESC").ransack(params[:q])
    # @q = PreApplication.order(updated_at: "DESC").ransack(params[:q])
    @pre_applications = @q.result(distinct: true).page(params[:page]).per(PER)
  end

  def show
  end

  def new
    @pre_application = PreApplication.new
    @pre_application.approvals.build
    @pre_application.reports.build
  end

  def edit
    n = 0
    @pre_application.approvals.each do |approval|
      if approval.judge != nil
        n +=1
      end
    end
    if n != 0
      redirect_to @pre_application, notice: "既に承認者が操作済みのため編集できません。"
    end
  end

  def create
    @pre_application = PreApplication.new(pre_application_params)

    respond_to do |format|
      if @pre_application.save
        @pre_application.create_overall_approval
        format.html { redirect_to @pre_application, notice: 'Pre application was successfully created.' }
        format.json { render :show, status: :created, location: @pre_application }

        #Slackへの通知
        notifier = Slack::Notifier.new(
          ENV['WEBHOOK_URL'],
          channel: '#' + ENV['CHANNEL']
        )
        approver1 = "<@" + @pre_application.approvals.first.user.slack_member_id + ">" if @pre_application.approvals.first
        approver2 = "<@" + @pre_application.approvals.second.user.slack_member_id + ">" if @pre_application.approvals.second
        approver3 = "<@" + @pre_application.approvals.third.user.slack_member_id + ">" if @pre_application.approvals.third

        message = <<~"EOS"
        新規申請があります。
        分野：#{@pre_application.genre}
        項目：#{@pre_application.item}
        承認者：#{approver1} #{approver2 if approver2} #{approver3 if approver3}
        <#{pre_application_url(@pre_application)}|ここ>にアクセスして承認してください。
        EOS
        notifier.ping(message)
      else
        format.html { render :new }
        format.json { render json: @pre_application.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @pre_application.update(pre_application_params)
        #添付ファイルの削除機能
        if params[:pre_application][:attached_file_ids].present?
          params[:pre_application][:attached_file_ids].each do |attached_file_id|
            attached_file = @pre_application.attached_files.find(attached_file_id)
            attached_file.purge
          end
        end

        format.html { redirect_to @pre_application, notice: 'Pre application was successfully updated.' }
        format.json { render :show, status: :ok, location: @pre_application }
      else
        format.html { render :edit }
        format.json { render json: @pre_application.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    n = 0
    @pre_application.approvals.each do |approval|
      if approval.judge != nil
        n +=1
      end
    end

    if n != 0
      redirect_to @pre_application, notice: "既に承認者が操作済みのため削除できません。"
    else
      @pre_application.destroy
      respond_to do |format|
        format.html { redirect_to pre_applications_url, notice: 'Pre application was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pre_application
      @pre_application = PreApplication.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pre_application_params
      params.require(:pre_application).permit(:user_id, :genre, :item, :description, :amount,
        approvals_attributes: [:id, :user_id,:order, :_destroy],
        reports_attributes: [:id, :user_id, :_destroy],
        attached_files: [])
    end

    def authenticate_editer
      if current_user != @pre_application.user
        redirect_to pre_applications_path, notice: "編集権限がありません。"
      end
    end

    def authenticate_viewer
      approver = @pre_application.approvals.map{ |approval| approval.user_id }.include?(current_user.id)
      reported_person = @pre_application.reports.map{ |report| report.user_id }.include?(current_user.id)
      if (current_user == @pre_application.user) or approver or reported_person
      else
        redirect_to pre_applications_path, notice: "閲覧権限がありません。"
      end
    end
end
