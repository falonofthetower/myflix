require "spec_helper"

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid inupt and valid card" do
      let(:charge) { double(:charge, successful?: true) }

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "invitation acceptance successful" do
      let(:charge) { double(:charge, successful?: true) }

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "makes the user follow the inviter" do
        luke = Fabricate(:user)
        invitation = Fabricate(
          :invitation,
          inviter: luke,
          recipient_email: "hans@falcon.com"
        )
        post :create, user: {
          email: "hans@falcon.com",
          full_name: "Hans Solo",
          password: "password"
        }, invitation_token: invitation.token

        hans = User.where(email: "hans@falcon.com").first
        expect(hans.follows?(luke)).to be_truthy
      end

      it "make the inviter follow the user" do
        luke = Fabricate(:user)
        invitation = Fabricate(
          :invitation,
          inviter: luke,
          recipient_email: "hans@falcon.com"
        )
        post :create, user: {
          email: "hans@falcon.com",
          full_name: "Hans Solo",
          password: "password"
        }, invitation_token: invitation.token

        hans = User.where(email: "hans@falcon.com").first
        expect(luke.follows?(hans)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        luke = Fabricate(:user)
        invitation = Fabricate(
          :invitation,
          inviter: luke,
          recipient_email: "hans@falcon.com"
        )
        post :create, user: {
          email: "hans@falcon.com",
          full_name: "Hans Solo",
          password: "password"
        }, invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil
      end
    end

    context "with valid input but invalid card" do
      let(:charge) do
        double(
          :charge,
          successful?: false, error_message: "Your card was declined"
        )
      end

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user),
                      stripeToken: "12345678"
      end

      it "does not create a new user record" do
        expect(User.count).to eq(0)
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        expect(flash[:danger]).to be_present
      end
    end

    context "with invalid input" do
      before do
        post :create, user: { password: "serenity", full_name: "Nathon Fillion" }
      end

      it "does not create user" do
        expect(User.count).to eq(0)
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
        post :create, user: { email: "vadar@death_star.gov" }
      end

      it "email does not send given invalid inputs" do
        post :create, user: {
          email: "example@example.com",
          full_name: "The Wizard of Id",
          password: ""
        }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "email sending" do
      let(:charge) { double(:charge, successful?: true) }
      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(
          :user, email: "example@example.com", full_name: "The Wizard of Id"
        )
      end

      it "sends out the email given valid inputs" do
        expect(
          ActionMailer::Base.deliveries.last.to
        ).to eq(["example@example.com"])
      end

      it "email sent out has users name" do
        expect(
          ActionMailer::Base.deliveries.last.body
        ).to include("The Wizard of Id")
      end
    end
  end

  describe "GET show" do
    let(:luke) { Fabricate(:user) }

    it "sets @user" do
      set_current_user
      get :show, id: luke.id
      expect(assigns(:user)).to eq(luke)
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: luke.id }
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders the :new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to exipred token page for invalid tokens" do
      get :new_with_invitation_token, token: "random_blah"
      expect(response).to redirect_to expired_token_path
    end
  end
end
