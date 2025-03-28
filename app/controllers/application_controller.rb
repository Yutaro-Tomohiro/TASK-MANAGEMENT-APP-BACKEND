class ApplicationController < ActionController::Base
  include ActionController::Cookies

  rescue_from BadRequestError, with: :handle_error
  rescue_from ConflictError, with: :handle_error
  rescue_from StandardError, with: :handle_error

  private

  def handle_error(error)
    error = ApplicationError.wrap(error)

    render json: { error: error.message }, status: error.default_code
  end
end
