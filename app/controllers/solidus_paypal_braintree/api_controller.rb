module SolidusPaypalBraintree
  class ApiController < ActionController::Base
    layout false
    skip_before_action :verify_authenticity_token
  end
end
