module SolidusPaypalBraintree
  class Subscription < ApplicationRecord
    belongs_to :spree_order, class_name: 'Spree::Order'
    belongs_to :user, class_name: 'User'
    belongs_to :payment_plan, class_name: 'PaymentPlan'
    has_many :transactions, class_name: 'SolidusPaypalBraintree::Transaction', foreign_key: :subscription_id
  end
end
