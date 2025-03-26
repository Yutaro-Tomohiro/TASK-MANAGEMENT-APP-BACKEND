class UserAuthenticationService
  include UserAuthenticationServiceInterface

  def initialize(user_repository, jwt_service)
    @user_repository = user_repository
    @jwt_service = jwt_service
  end

  def login_user(form)
    raise BadRequestError.new unless form.valid?

    user = @user_repository.authenticate_user(form.email, form.password)

    raise UnauthorizedError.new unless user

    {
      user: user,
      token: @jwt_service.generate_jwt(user.identity)
    }
  end
end
