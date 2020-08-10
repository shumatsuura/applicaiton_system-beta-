class PreApplicationsController < ApplicationController
  before_action :set_pre_application, only: [:show, :edit, :update, :destroy]

  # GET /pre_applications
  # GET /pre_applications.json
  def index
    @pre_applications = PreApplication.all
  end

  # GET /pre_applications/1
  # GET /pre_applications/1.json
  def show
  end

  # GET /pre_applications/new
  def new
    @pre_application = PreApplication.new
    @user = current_user
    @pre_application.approvals.build
  end

  # GET /pre_applications/1/edit
  def edit
  end

  # POST /pre_applications
  # POST /pre_applications.json
  def create
    @pre_application = PreApplication.new(pre_application_params)

    respond_to do |format|
      if @pre_application.save
        format.html { redirect_to @pre_application, notice: 'Pre application was successfully created.' }
        format.json { render :show, status: :created, location: @pre_application }
      else
        format.html { render :new }
        format.json { render json: @pre_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pre_applications/1
  # PATCH/PUT /pre_applications/1.json
  def update
    respond_to do |format|
      if @pre_application.update(pre_application_params)
        format.html { redirect_to @pre_application, notice: 'Pre application was successfully updated.' }
        format.json { render :show, status: :ok, location: @pre_application }
      else
        format.html { render :edit }
        format.json { render json: @pre_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pre_applications/1
  # DELETE /pre_applications/1.json
  def destroy
    @pre_application.destroy
    respond_to do |format|
      format.html { redirect_to pre_applications_url, notice: 'Pre application was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pre_application
      @pre_application = PreApplication.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pre_application_params
      params.require(:pre_application).permit(:user_id, :genre, :item, :description, :amount, approvals_attributes: [:id, :user_id])
    end
end
