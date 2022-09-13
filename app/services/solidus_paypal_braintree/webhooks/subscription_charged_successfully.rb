module SolidusPaypalBraintree
  module Webhooks
    class SubscriptionChargedSuccessfully
      include Interactor
      include BaseService

      requires :braintree_subscription

      # TODO: Create transactions
      def call
        puts braintree_subscription.id
        puts braintree_subscription.plan_id
        puts braintree_subscription.price
      end
    end
  end
end
