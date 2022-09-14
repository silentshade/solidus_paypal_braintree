module SolidusPaypalBraintree
  module Webhooks
    module SubscriptionMethods
      def find_subscription
        @subscription = SolidusPaypalBraintree::Subscription.find_by!(braintree_id: braintree_subscription.id)
      end
    end
  end
end
