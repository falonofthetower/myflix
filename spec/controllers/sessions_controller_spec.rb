require 'spec_helper'

describe SessionsController do
  describe "GET new" do

    it "renders the new template for unauthenticaed users" do
      get :new
      expect(response).to render_template(:new)
    end

    it "redirects to the home page for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "Post create" do
    context "with valid credentials" do
      let(:batman) { Fabricate(:user) }
      before do
        post :create, email: batman.email, password: batman.password
      end

      it "puts signed in user in the session" do 
        expect(session[:user_id]).to eq(batman.id)
      end

      it "redirects to the home page" do
        expect(response).to redirect_to home_path
      end

      it "sets the notice" do
        expect(flash[:success]).not_to be_blank
      end
    end

    context "with invalid credentials" do
      before do
        batman = Fabricate(:user)
        post :create, email: batman.email, password: "#{batman.password}blah"
      end

      it "does not put a user in the session" do
        expect(session[:user_id]).to be_nil
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end
      it "sets the danger message" do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end
    it "clears the session for the user" do
      expect(session[:user_id]).to be_nil
    end

    it "redirect_to root_path" do
      expect(response).to redirect_to root_path
    end

    it "sets the notice" do
      expect(flash[:notice]).not_to be_blank
    end
  end
end
