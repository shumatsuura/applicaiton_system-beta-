class ApplicationController < ActionController::Base

  private

  def admin_user?
    if user_signed_in? && current_user.admin
      true
    else
      false
    end
  end

  def ensure_admin_user
    redirect_to root_path, alert: "No Access Right." unless admin_user?
  end
end
