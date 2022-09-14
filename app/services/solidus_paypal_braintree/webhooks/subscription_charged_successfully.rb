module SolidusPaypalBraintree
  module Webhooks
    class SubscriptionChargedSuccessfully
      include Interactor
      include BaseService
      include SubscriptionMethods

      requires :braintree_subscription
      attr_reader :subscription

      # TODO: Create transactions
      def call
        find_subscription
        create_transactions
      end

      private

      def create_transactions
        attrs = braintree_subscription.transactions.map do |tr|
          {
            subscription_id: subscription.id,
            braintree_id: tr.id,
            braintree_subscription_id: braintree_subscription.id,
            status: tr.status,
            amount: tr.amount,
            payment_method: SolidusPaypalBraintree::SubscriptionGateway.name
          }
        end
        SolidusPaypalBraintree::Transaction.upsert_all(attrs, unique_by: :braintree_id)
      end
    end
  end
end
