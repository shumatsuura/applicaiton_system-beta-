class RemoteWorksController < ApplicationController
  before_action :set_remote_work, only:[:show,:edit,:update,:destroy]

  PER = 50

  def index
    @q = RemoteWork.order(updated_at: "DESC").ransack(params[:q])
    @remote_works = @q.result(distinct: true).page(params[:page]).per(PER)
  end

  def new
    @user = current_user
    @remote_work = RemoteWork.new
    @remote_dates = (-15..15).map {|d| Date.today + d}
  end

  def create
    @user = current_user
    applied_dates = []

    remote_dates = remote_work_params[:remote_dates]

    #checked_valueとunchecked_value両方が送信されるのでchecked_valueが存在する場合にunchecked_valueを削除
    remote_work_params[:remote_dates].each do |s|
      if s.include?("unchecked") && remote_dates.include?(s.delete("unchecked"))
          remote_dates.delete(s)
      end
    end
    
    remote_dates.each do |t|
      #チェックした日付が既に申請済みの場合、処理なし
      if @user.remote_works.map { |a| a.remote_date.to_s}.include?(t)
      else
        #送信値が未チェックか判定
        if t.include?("unchecked")
          unchecked = Date.strptime(t.delete("unchecked"))
          #未チェックの日付が申請済みの場合、削除
          if @user.remote_works.map { |a| a.remote_date}.include?(unchecked)
            @user.remote_works.find_by(remote_date: unchecked).destroy
          end
        #チェックした日付がまだ未申請の場合、申請作成
        else
          remote_work = RemoteWork.new
          remote_work.user_id = remote_work_params[:user_id]
          remote_work.remote_date = t
          remote_work.save
          applied_dates.push(t)
        end
      end
    end

    #Slackへの通知
    notifier = Slack::Notifier.new(ENV['WEBHOOK_URL'],channel: '#' + ENV['CHANNEL'])
    mention = "<@" + @user.slack_member_id + ">"
    message = <<~"EOS"
    フルリモート申請
    申請者：#{@user.name} #{mention}
    フルリモート申請日：#{applied_dates}
    EOS
    notifier.ping(message)

    redirect_to remote_works_path
  end

  def edit

  end

  def update
    if @remote_work.update(remote_work_params)
      redirect_to remote_works_path(@remote_work.id)
    else
      render 'edit'
    end
  end

  private

  def set_remote_work
    @remote_work = RemoteWork.find(params[:id])
  end

  def remote_work_params
    params.require(:remote_work).permit(:user_id,:remote_date,remote_dates: [])
  end
end
