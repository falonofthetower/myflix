require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid inupt" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "email sending" do
      let(:luke) { Fabricate(:user) }
      before do
        post :create, user: Fabricate.attributes_for(:user, email: "example@example.com", full_name: "The Wizard of Id")
      end

      it "sends out the email" do
        ActionMailer::Base.deliveries.should_not be_empty
      end

      it "has the correct recipient" do
        message = ActionMailer::Base.deliveries.last
        message.to.should == ["example@example.com"]
      end

      it "has the correct name" do 
        message = ActionMailer::Base.deliveries.last
        message.body.should include("The Wizard of Id")
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
end
