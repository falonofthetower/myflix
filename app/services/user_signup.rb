class UserSignup
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        amount: 999,
        source: stripe_token,
        description: "Sign up charge for #{@user.email}"
      )
      if charge.successful?
        @user.save
        handle_invitation(invitation_token)
        @status = :success
        AppMailer.delay.welcome(@user)
        self
      else
        @status = :failure
        @error_message = charge.error_message
        self
      end
    else
      @status = :failure
      @error_message = "Invalid user info, please fix highlighted fields"
      self
    end
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.where(token: invitation_token).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end