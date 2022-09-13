module SolidusPaypalBraintree
  module Webhooks
    class SubscriptionCanceled
      include Interactor
      include BaseService

      requires :braintree_subscription
      attr_reader :subscription

      def call
        find_subscription
        cancel_subscription
      end

      private

      def find_subscription
        @subscription = SolidusPaypalBraintree::Subscription.find_by!(braintree_id: braintree_subscription.id)
      end

      def cancel_subscription
        subscription.update! status: braintree_subscription.status
      end
    end
  end
end
