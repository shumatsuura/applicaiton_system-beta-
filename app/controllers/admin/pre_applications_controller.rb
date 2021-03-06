class Admin::PreApplicationsController < ApplicationController
  before_action :set_pre_application, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :ensure_admin_user

  PER = 50

  def index
    @q = PreApplication.order(updated_at: "DESC").ransack(params[:q])
    @pre_applications = @q.result(distinct: true).page(params[:page]).per(PER)
  end

  def show
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

  def update
    respond_to do |format|
      if @pre_application.update(pre_application_params)
        format.html { redirect_to admin_pre_application_path(@pre_application), notice: 'Pre application was successfully updated.' }
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
end
