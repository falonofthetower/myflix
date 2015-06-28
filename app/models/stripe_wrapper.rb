module StripeWrapper
  class Charge
    attr_reader :error_message, :response
    def initialize(options = {})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options = {})
      response = Stripe::Charge.create(
        amount: options[:amount],
        currency: "usd",
        source: options[:source],
        description: options[:description]
      )
      new(response: response)
    rescue Stripe::CardError => e
      new(error_message: e.message)
    end

    def successful?
      response.present?
    end
  end

  class Customer
    attr_reader :response, :error_message
    def initialize(options = {})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options = {})
      response = Stripe::Customer.create(
        source: options[:source],
        plan: "golden",
        email: options[:user].email
      )
      new(response: response)
    rescue Stripe::CardError => e
      new(error_message: e.message)
    end

    def successful?
      response.present?
    end
  end
end
