require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets the @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
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
      it "redirects to the invitation new page" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Black", recipient_email: "hades@hell.com", message: "When I introduce you, and I tell them who you are, I don't think anyone will stay for dinner." }
        expect(response).to redirect_to new_invitation_path
      end

      it "creates an invitation" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Black", recipient_email: "hades@hell.com", message: "When I introduce you, and I tell them who you are, I don't think anyone will stay for dinner." }
        expect(Invitation.count).to eq(1)
      end

      it "sends an email to the recipient" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Black", recipient_email: "hades@hell.com", message: "When I introduce you, and I tell them who you are, I don't think anyone will stay for dinner." }
        expect(ActionMailer::Base.deliveries.last.to).to eq(["hades@hell.com"])
      end

      it "sets the flash success page" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Black", recipient_email: "hades@hell.com", message: "When I introduce you, and I tell them who you are, I don't think anyone will stay for dinner." }
        expect(flash[:success]).to be_present

      end
    end

    context "with invalid input" do

      before { ActionMailer::Base.deliveries.clear }

      it "renders the :new template" do
        set_current_user
        post :create, invitation: { recipient_email: "hades@hell.com", message: "When I introduce you, and I tell them who you are, I don't think anyone will stay for dinner." }
        expect(response).to render_template :new
      end

      it "does not create invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "hades@hell.com", message: "When I introduce you, and I tell them who you are, I don't think anyone will stay for dinner." }
        expect(Invitation.count).to eq(0)
      end

      it "does not send the email" do
        set_current_user
        post :create, invitation: { recipient_email: "hades@hell.com", message: "When I introduce you, and I tell them who you are, I don't think anyone will stay for dinner." }
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets the flash danger message" do
        set_current_user
        post :create, invitation: { recipient_email: "hades@hell.com", message: "When I introduce you, and I tell them who you are, I don't think anyone will stay for dinner." }
        expect(flash[:danger]).to be_present
      end

      it "sets the @invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "hades@hell.com", message: "When I introduce you, and I tell them who you are, I don't think anyone will stay for dinner." }
        expect(assigns(:invitation)).to be_instance_of(Invitation)
      end
    end
  end
end
