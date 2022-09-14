# frozen_string_literal: true

require 'active_model'

module SolidusPaypalBraintree
  class Transaction < ApplicationRecord
    attr_accessor :nonce, :payment_type, :paypal_funding_source, :address, :email, :phone, :imported

    belongs_to :subscription, class_name: 'SolidusPaypalBraintree::Subscription', optional: true, foreign_key: :subscription_id

    with_options(if: -> { imported }) do
      validates :nonce, presence: true
      validates :payment_type, presence: true
      validates :email, presence: true
    end

    with_options(unless: -> { imported} ) do
      validates :braintree_id, presence: true, uniqueness: true
      validates :status, presence: true
      validates :amount, numericality: { greater_than: 0 }
    end

    validates :payment_method, presence: true

    validate do
      unless %w(SolidusPaypalBraintree::Gateway SolidusPaypalBraintree::SubscriptionGateway).include?(payment_method)
        errors.add(:payment_method, 'Must be braintree')
      end
      if address && !address.valid?
        address.errors.each do |field, error|
          errors.add(:address, "#{field} #{error}")
        end
      end
    end

    def address_attributes=(attributes)
      self.address = TransactionAddress.new attributes
    end
  end
end
