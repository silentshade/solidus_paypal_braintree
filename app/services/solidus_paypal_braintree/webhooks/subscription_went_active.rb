module SolidusPaypalBraintree
  module Webhooks
    class SubscriptionWentActive
      include Interactor
      include BaseService

      requires :braintree_subscription
      attr_reader :subscription

      def call
        find_subscription
        update_subscription
      end

      private

      def find_subscription
        @subscription = SolidusPaypalBraintree::Subscription.find_by!(braintree_id: braintree_subscription.id)
      end

      def update_subscription
        subscription.update! status: braintree_subscription.status,
                             braintree_id: braintree_subscription.id,
                             braintree_plan_id: braintree_subscription.plan_id,
                             first_billing_date: braintree_subscription.first_billing_date,
                             price: braintree_subscription.price,
                             next_billing_date: braintree_subscription.next_billing_date,
                             next_billing_period_amount: braintree_subscription.next_billing_period_amount,
                             trial_period: braintree_subscription.trial_period,
                             trial_duration: braintree_subscription.trial_duration,
                             trial_duration_unit: braintree_subscription.trial_duration_unit

      end
    end
  end
end
