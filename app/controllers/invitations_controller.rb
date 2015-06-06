class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    if @invitation.save
      send_invitation_email
      redirect_to new_invitation_path
    else
      flash[:danger] = "Invalid input"
      render :new
    end
  end

  def send_invitation_email
    AppMailer.send_invitation(@invitation).deliver
    flash[:success] = "Invitation sent!"
  end

  def invitation_params
    params[:invitation].merge!(inviter_id: current_user.id)
    params.require(:invitation).permit(:recipient_name,
                                       :recipient_email,
                                       :message,
                                       :inviter_id)
  end
end
