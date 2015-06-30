require "spec_helper"

describe "Deactives user on failed charge" do
  let(:event_data) do
    {
      "id" => "evt_16J7wqCgpBrdIpYjZD5jb071",
      "created" => 1435606184,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_16J7wqCgpBrdIpYjqOa1w2YR",
          "object" => "charge",
          "created" => 1435606184,
          "livemode" => false,
          "paid" => false,
          "status" => "failed",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_16J7w5CgpBrdIpYjfQpADsC6",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 6,
            "exp_year" => 2016,
            "fingerprint" => "imfn5PVKb6jKVlYV",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "tokenization_method" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => "cus_6VyGVJA97JdnOt"
          },
          "captured" => false,
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_6VyGVJA97JdnOt",
          "invoice" => nil,
          "description" => "failure",
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => nil,
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "destination" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_16J7wqCgpBrdIpYjqOa1w2YR/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_6WAHA3v88zinM5",
      "api_version" => "2015-04-07"
    }
  end

  it "deactivates account using webhook from stripe failed charge" do
    luke = Fabricate(:user, customer_token: "cus_6VyGVJA97JdnOt", active: true)
    post "/stripe_event", event_data
    expect(luke.reload).not_to be_active
  end
end
