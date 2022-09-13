module BaseService
  extend ActiveSupport::Concern
  included do |base|
    base.include ActiveModel::Validations
    base.around :handle_errors
    base.before do
      unless valid?
        context.fail!(message: "Required attributes are not passed for #{base.name}", errors:) # runs every validation
      end
    end
  end

  class_methods do
    def requires(*attributes)
      validates_each attributes do |_record, attr_name, value| # from ActiveModel::Validations
        raise ArgumentError, "Required attribute #{attr_name} is missing" if value.nil?
      end
      delegate(*attributes, to: :context)
    end
  end

  private

  def handle_errors(interactor)
    interactor.call
  rescue Interactor::Failure => e
    raise e
  rescue StandardError => e
    if Rails.env.development?
      Rails.logger.info e.message
      Rails.logger.info e.backtrace.join("\n")
    end
    context.fail! message: e.message, error: context.error || e
  end
end
