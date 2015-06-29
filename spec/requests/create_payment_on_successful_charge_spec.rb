require 'spec_helper'

describe "create a payment on succesful charge", :vcr do
  let(:event_data) {
    {
      "id"=> "evt_16Iu9OCgpBrdIpYj9NQqAegb",
      "created"=> 1435553146,
      "livemode"=> false,
      "type"=> "charge.succeeded",
      "data"=> {
        "object"=> {
          "id"=> "ch_16Iu9OCgpBrdIpYjArgIbvSD",
          "object"=> "charge",
          "created"=> 1435553146,
          "livemode"=> false,
          "paid"=> true,
          "status"=> "succeeded",
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "source"=> {
            "id"=> "card_16Iu9NCgpBrdIpYj725ywf4i",
            "object"=> "card",
            "last4"=> "4242",
            "brand"=> "Visa",
            "funding"=> "credit",
            "exp_month"=> 6,
            "exp_year"=> 2015,
            "fingerprint"=> "WK9Xk0j3v4YY5hjj",
            "country"=> "US",
            "name"=> nil,
            "address_line1"=> nil,
            "address_line2"=> nil,
            "address_city"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_country"=> nil,
            "cvc_check"=> "pass",
            "address_line1_check"=> nil,
            "address_zip_check"=> nil,
            "tokenization_method"=> nil,
            "dynamic_last4"=> nil,
            "metadata"=> {},
            "customer"=> "cus_6Vw1bCqE3Uqptz"
          },
          "captured"=> true,
          "balance_transaction"=> "txn_16Iu9OCgpBrdIpYjETlbDUnc",
          "failure_message"=> nil,
          "failure_code"=> nil,
          "amount_refunded"=> 0,
          "customer"=> "cus_6Vw1bCqE3Uqptz",
          "invoice"=> "in_16Iu9OCgpBrdIpYjQqhnOe0w",
          "description"=> nil,
          "dispute"=> nil,
          "metadata"=> {},
          "statement_descriptor"=> "Video nirvana",
          "fraud_details"=> {},
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "shipping"=> nil,
          "destination"=> nil,
          "application_fee"=> nil,
          "refunds"=> {
            "object"=> "list",
            "total_count"=> 0,
            "has_more"=> false,
            "url"=> "/v1/charges/ch_16Iu9OCgpBrdIpYjArgIbvSD/refunds",
            "data"=> []
          }
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_6Vw1Li08FlPYGF",
      "api_version"=> "2015-04-07"
    }
  }

  it "creates payment using webhook from stripe for successful charge" do
    post '/stripe_event', event_data
    expect(Payment.count).to eq(1)
  end

  it "creates payments associated with the user" do
    luke = Fabricate(:user, customer_token: "cus_6Vw1bCqE3Uqptz")
    post '/stripe_event', event_data
    expect(Payment.first.user).to eq(luke)
  end

  it "creates the payment for the correct amount" do
    luke = Fabricate(:user, customer_token: "cus_6Vw1bCqE3Uqptz")
    post '/stripe_event', event_data
    expect(Payment.first.amount).to eq("999")
  end

  it "creates the payment with the reference_id" do
    luke = Fabricate(:user, customer_token: "cus_6Vw1bCqE3Uqptz")
    post '/stripe_event', event_data
    expect(Payment.first.reference_id).to eq("ch_16Iu9OCgpBrdIpYjArgIbvSD")
  end
end
