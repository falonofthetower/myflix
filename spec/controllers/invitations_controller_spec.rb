require "spec_helper"

describe InvitationsController do
  describe "GET new" do
    it "sets the @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_a_new Invitation
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    context "with valid input" do
      before do
        set_current_user
        post :create, invitation: {
          recipient_name: "Joe Black",
          recipient_email: "hades@hell.com",
          message: "When I introduce you, and I tell them who you are, \
          I don't think anyone will stay for dinner."
        }
      end

      it "redirects to the invitation new page" do
        expect(response).to redirect_to new_invitation_path
      end

      it "creates an invitation" do
        expect(Invitation.count).to eq(1)
      end

      it "sends an email to the recipient" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["hades@hell.com"])
      end

      it "sets the flash success page" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      before do
        set_current_user
        post :create, invitation: {
          recipient_email: "hades@hell.com",
          message: "When I introduce you, and I tell them who you are, \
          I don't think anyone will stay for dinner." }
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "does not create invitation" do
        expect(Invitation.count).to eq(0)
      end

      it "does not send the email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets the flash danger message" do
        expect(flash[:danger]).to be_present
      end

      it "sets the @invitation" do
        expect(assigns(:invitation)).to be_instance_of(Invitation)
      end
    end
  end
end
