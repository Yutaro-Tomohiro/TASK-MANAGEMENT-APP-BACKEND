class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :create, :login ]

  def create
    form = UserRegistrationForm.new(create_params)

    UserService.new(UserRepository.new).register_user(form)
    head :created
  end

  def login
    form = UserLoginForm.new(login_params)

    result = UserAuthenticationService.new(UserRepository.new, JwtService.new).login_user(form)

    set_jwt_cookie(result[:token])

    render json: { user_id: result[:user].identity, name: result[:user].name }, status: :ok
  end

  private

  def create_params
    params.permit(:name, :email, :password)
  end

  def login_params
    params.permit(:email, :password)
  end

  def set_jwt_cookie(token)
    cookies.signed[:jwt] = {
      value: token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :strict
    }
  end
end
