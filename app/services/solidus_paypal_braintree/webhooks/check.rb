module SolidusPaypalBraintree
  module Webhooks
    class Check
      include Interactor
      include BaseService

      def call
        Rails.logger.debug 'Check passed'
      end
    end
  end
end
