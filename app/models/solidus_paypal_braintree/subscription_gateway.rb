require 'solidus_paypal_braintree/gateway'

module SolidusPaypalBraintree
  class SubscriptionGateway < Gateway
    # Create plan and subscribe
    #
    # @api public
    # @param money_cents [Number, String] amount to authorize
    # @param payment_source [Source] payment source
    # @param gateway_options [Hash]
    #   extra options to send along. e.g.: device data for fraud prevention
    # @return [Response]
    def purchase(money_cents, payment_source, gateway_options)
      params = { plan_id: gateway_options[:originator].payment_plan.braintree_plan_id }

      if payment_source.token
        params[:payment_method_token] = payment_source.token
      else
        params[:payment_method_nonce] = payment_source.nonce
      end

      protected_request do
        result = braintree.subscription.create(**params)
        begin
          create_subscription(result.subscription.id, gateway_options[:originator])
        rescue ActiveRecord::ActiveRecordError => e
          braintree.subscription.cancel!(result.subscription.id)
          raise e
        end
        Response.build(result)
      end
    end

    def create_subscription(id, payment)
      SolidusPaypalBraintree::Subscription.create! braintree_id: id,
                                                   status: :initial,
                                                   spree_order: payment.order,
                                                   user: payment.order.user,
                                                   payment_plan_id: payment.payment_plan_id
    end
  end
end
