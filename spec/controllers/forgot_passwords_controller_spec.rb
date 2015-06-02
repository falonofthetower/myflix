require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank email" do
      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end

      it "shows and error message" do
        post :create, email: ''
        expect(flash[:danger]).to eq("There is no account with that email")
      end
    end

    context "with existing email" do

      after { ActionMailer::Base.deliveries.clear }

      it "redirects to the forgot password confirmation page" do
        Fabricate(:user, email: "joker@arkham.com")
        post :create, email: "joker@arkham.com"
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "sends out email to the address" do
        Fabricate(:user, email: "joker@arkham.com")
        post :create, email: "joker@arkham.com"
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joker@arkham.com"])
      end
    end

    context "with non-existing email" do

      after { ActionMailer::Base.deliveries.clear }

      it "redirects to the forgot_password_confirmation_path" do
        post :create, email: "joker@arkham.com"
        expect(response).to redirect_to forgot_password_path
      end

      it "Does not send the email" do
        post :create, email: "joker@arkham.com"
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
