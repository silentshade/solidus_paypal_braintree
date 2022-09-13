module SolidusPaypalBraintree
  class Subscription < ApplicationRecord
    belongs_to :spree_order, class_name: 'Spree::Order'
    belongs_to :user, class_name: 'User'
    belongs_to :payment_plan, class_name: 'PaymentPlan'
  end
end
