require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "valid personal info and valid card" do
      let(:charge) { double(:charge, successful?: true) }

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe_token", nil)
        expect(User.count).to eq(1)
      end
    end

    context "invitation acceptance successful" do
      let(:charge) { double(:charge, successful?: true) }
      let(:luke) { Fabricate(:user) }
      let(:invitation) do
        Fabricate(:invitation, inviter: luke, recipient_email: "hans@falcon.com")
      end

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        UserSignup.new(
          Fabricate.build(
            :user,
            email: "hans@falcon.com",
            full_name: "Hans Solo",
            password: "password"
          )
        ).sign_up("stripe_token", invitation.token)
      end

      it "makes the user follow the inviter" do
        hans = User.where(email: "hans@falcon.com").first
        expect(hans.follows?(luke)).to be_truthy
      end

      it "make the inviter follow the user" do
        hans = User.where(email: "hans@falcon.com").first
        expect(luke.follows?(hans)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        expect(Invitation.first.token).to be_nil
      end
    end

    context "email sending" do
      let(:charge) { double(:charge, successful?: true) }

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        UserSignup.new(
          Fabricate.build(:user, email: "example@example.com", full_name: "The Wizard of Id")
        ).sign_up("stripe_token", nil)
      end

      it "sends out the email" do
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

    context "with valid input but invalid card" do
      let(:charge) do
        double(:charge,
          successful?: false, error_message: "Your card was declined"
        )
      end

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe_token", nil)
      end

      it "does not create a new user record" do
        expect(User.count).to eq(0)
      end
    end

    context "with invalid input" do
      before do
        UserSignup.new(
          User.new(
            email:"email@example.com",
            full_name: "no password"
          )).sign_up("stripe_token", nil)
      end

      it "does not create user" do
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
      end

      it "email does not send given invalid inputs" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
