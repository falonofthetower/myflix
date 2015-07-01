require "spec_helper"

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      card: {
        number: "4242424242424242",
        exp_month: Time.new.month,
        exp_year: Time.new.year,
        cvc: 123
      }
    ).id
  end

  let(:declined_token) do
    Stripe::Token.create(
      card: {
        number: "4000000000000002",
        exp_month: Time.new.month,
        exp_year: Time.new.year,
        cvc: 123
      }
    ).id
  end

  describe StripeWrapper::Charge, :vcr do
    describe ".create" do
      it "makes a successful charge" do
        response = StripeWrapper::Charge.create(
          amount: 999,
          source: valid_token,
          description: "A valid charge"
        )

        expect(response).to be_successful
      end

      it "makes a card declined charge" do
        response = StripeWrapper::Charge.create(
          amount: 999,
          source: declined_token,
          description: "an invalid charge"
        )
        expect(response).not_to be_successful
      end

      it "returns the error message for declined charges" do
        response = StripeWrapper::Charge.create(
          amount: 999,
          source: declined_token,
          description: "an invalid charge"
        )
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create", :vcr do
      it "creates a customer with a valid card" do
        luke = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          source: valid_token,
          user: luke
        )
        expect(response).to be_successful
      end

      it "associates the customer with a user with valid card" do
        luke = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          source: valid_token,
          user: luke
        )
        expect(response.customer_token).to be_present
      end

      it "does not create a customer with declined card" do
        luke = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          source: declined_token,
          user: luke
        )
        expect(response).not_to be_successful
      end

      it "returns the error message for declined card" do
        luke = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          source: declined_token,
          user: luke
        )
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end
