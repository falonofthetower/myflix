require "spec_helper"

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "successful sign up" do
      let(:charge) { double(:charge, successful?: true) }

      it "redirects to the sign in page" do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end
    end

    context "failed sign up" do
      before do
        result = double(
          :sign_up_result,
          successful?: false,
          error_message: "This is failure"
        )
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "does not create a new user record" do
        expect(User.count).to eq(0)
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        expect(flash[:danger]).to eq("This is failure")
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
