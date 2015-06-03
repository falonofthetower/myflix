require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank email" do
      before do
        post :create, email: ''
      end

      it "redirects to the forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end

      it "shows and error message" do
        expect(flash[:danger]).to eq("There is no account with that email")
      end
    end

    context "with existing email" do
      after { ActionMailer::Base.deliveries.clear }

      before do
        Fabricate(:user, email: "joker@arkham.com")
        post :create, email: "joker@arkham.com"
      end

      it "redirects to the forgot password confirmation page" do
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "sends out email to the address" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joker@arkham.com"])
      end
    end

    context "with non-existing email" do
      after { ActionMailer::Base.deliveries.clear }

      before do
        post :create, email: "joker@arkham.com"
      end

      it "redirects to the forgot_password_confirmation_path" do
        expect(response).to redirect_to forgot_password_path
      end

      it "Does not send the email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
