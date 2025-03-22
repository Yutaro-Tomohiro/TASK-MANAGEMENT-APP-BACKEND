class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :create ]
  rescue_from BadRequestError, with: :handle_error
  rescue_from ConflictError, with: :handle_error
  rescue_from InternalServerError, with: :handle_error

  def create
    form = UserRegistrationForm.new(user_params)

    UserService.new(UserRepository.new).register_user(form)
    head :created
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
