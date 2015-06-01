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

      after { ActionMailer::Base.deliveries.clear }

      it "sends out the email given valid inputs" do
        post :create, user: Fabricate.attributes_for(:user, email: "example@example.com", full_name: "The Wizard of Id")
        expect(ActionMailer::Base.deliveries.last.to).to eq(["example@example.com"])
      end

      it "email sent out has users name" do
        post :create, user: Fabricate.attributes_for(:user, email: "example@example.com", full_name: "The Wizard of Id")
        expect(ActionMailer::Base.deliveries.last.body).to include("The Wizard of Id")
      end

      it "email does not send given invalid inputs" do
        post :create, user: { email: "example@example.com", full_name: "The Wizard of Id", password: "" }
        expect(ActionMailer::Base.deliveries).to be_empty
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
