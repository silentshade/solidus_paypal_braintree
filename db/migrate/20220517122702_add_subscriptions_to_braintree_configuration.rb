class AddSubscriptionsToBraintreeConfiguration < ActiveRecord::Migration[7.0]
  def change
    add_column :solidus_paypal_braintree_configurations, :subscriptions, :boolean, null: false, default: false
  end
end
