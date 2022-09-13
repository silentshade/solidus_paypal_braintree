require 'braintree'

module SolidusPaypalBraintree
  class WebhooksController < ApiController
    def notify
      notification = parse_request
      service = select_service(notification)

      result = service.call(braintree_subscription: notification.subscription)
      return head :ok if result.success?

      head(:unprocessable_entity)
    end

    private

    def select_service(notification)
      name = ['SolidusPaypalBraintree', 'Webhooks', notification.kind.demodulize.classify].join('::')
      Rails.logger.debug "Calling #{name}"
      return name.constantize if defined?(name)

      raise "#{name} is not in available webhook handlers list"
    end

    def logger
      Braintree::Configuration.logger.clone.tap do |logger|
        logger.level = Rails.logger.level
      end
    end

    def braintree_config
      @_braintree_config ||= ::Spree::Config.static_model_preferences.for_class(SolidusPaypalBraintree::Gateway)['braintree_credentials']
    end

    def gateway_options
      {
        environment: braintree_config.fetch(:environment).to_sym,
        merchant_id: braintree_config.fetch(:merchant_id),
        public_key: braintree_config.fetch(:public_key),
        private_key: braintree_config.fetch(:private_key),
        http_open_timeout: 60,
        http_read_timeout: 60,
        logger: logger
      }
    end

    def gateway
      Braintree::Gateway.new(gateway_options)
    end

    def parse_request
      gateway.webhook_notification.parse(params[:bt_signature], params[:bt_payload])
    end
  end
end
