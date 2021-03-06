require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders the show template if the token is valid" do
      Fabricate(:user, token: '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end

    it "sets @token" do
      Fabricate(:user, token: '12345')
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345')
    end

    it "redirects to the expired token page if the token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do

    let(:luke) { Fabricate(:user, password: 'old_password') }
    before do
      luke.update_column(:token, '12345')
      post :create, token: '12345', password: 'new_password'
    end

    it "redirects to the sign in page" do
      expect(response).to redirect_to sign_in_path
    end

    it "updates the user's password" do
      expect(luke.reload.authenticate('new_password')).to be_truthy
    end

    it "sets the flash success message" do
      expect(flash[:success]).to be_present
    end

    it "deletes the user token" do
      expect(luke.reload.token).to be nil
    end
  end
end
