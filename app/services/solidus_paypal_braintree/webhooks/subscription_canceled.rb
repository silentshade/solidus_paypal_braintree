module SolidusPaypalBraintree
  module Webhooks
    class SubscriptionCanceled
      include Interactor
      include BaseService
      include SubscriptionMethods

      requires :braintree_subscription
      attr_reader :subscription

      def call
        find_subscription
        cancel_subscription
      end

      private

      def cancel_subscription
        subscription.update! status: braintree_subscription.status
      end
    end
  end
end
