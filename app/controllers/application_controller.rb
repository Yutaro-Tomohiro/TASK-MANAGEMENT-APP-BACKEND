class ApplicationController < ActionController::Base
  private

  def handle_error(error)
    error = ApplicationError.wrap(error)

    render json: { error: error.message }, status: error.default_code
  end
end
