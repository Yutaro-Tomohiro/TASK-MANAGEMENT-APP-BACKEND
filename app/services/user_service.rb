class UserService
  include UserServiceInterface

  def initialize(user_repository)
    @user_repository = user_repository
  end

  def register_user(form)
    raise BadRequestError.new unless form.valid?

    raise ConflictError.new if @user_repository.find_by_email(form.email)

    @user_repository.create(form.name, form.email, form.password)
  end
end
