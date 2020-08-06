class ReportsController < ApplicationController
  def index
    @reports = Report.where(id: current_user.id)
  end
end
