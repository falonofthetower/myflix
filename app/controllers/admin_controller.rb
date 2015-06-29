class AdminController < ApplicationController
  before_action :require_admin

  def require_admin
    unless current_user.admin?
      flash[:danger] = "You don't have authorization to do that"
      redirect_to home_path
    end
  end
end
