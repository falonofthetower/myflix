require "spec_helper"

describe UserSignup do
  describe "#sign_up", :vcr do
    context "valid personal info and valid card" do
      let(:customer) do
        double(
          :customer,
          successful?: true,
          customer_token: "token"
        )
      end

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "stores customer token from stripe" do
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe_token", nil)
        expect(User.first.customer_token).to eq("token")
      end
    end

    context "invitation acceptance successful" do
      let(:customer) do
        double(
          :customer,
          successful?: true,
          customer_token: "token"
        )
      end

      let(:luke) { Fabricate(:user) }
      let(:invitation) do
        Fabricate(
          :invitation,
          inviter: luke,
          recipient_email: "hans@falcon.com"
        )
      end

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
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
        hans = User.find_by(email: "hans@falcon.com")
        expect(hans.follows?(luke)).to be_truthy
      end

      it "make the inviter follow the user" do
        hans = User.find_by(email: "hans@falcon.com")
        expect(luke.follows?(hans)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        expect(Invitation.first.token).to be_nil
      end
    end

    context "email sending" do
      let(:customer) do
        double(
          :customer,
          successful?: true,
          customer_token: "token"
        )
      end

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(
          Fabricate.build(
            :user,
            email: "example@example.com",
            full_name: "The Wizard of Id"
          )
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
      let(:customer) do
        double(
          :customer,
          successful?: false,
          error_message: "Your card was declined"
        )
      end

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
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
            email: "email@example.com",
            full_name: "no password"
          )).sign_up("stripe_token", nil)
      end

      it "does not create user" do
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Customer.should_not_receive(:create)
      end

      it "email does not send given invalid inputs" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
