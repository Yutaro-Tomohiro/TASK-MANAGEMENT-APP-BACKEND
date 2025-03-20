class UserService
  def initialize(user_repository)
    @user_repository = user_repository
  end

  def register_user(form)
    @user_repository.create(form.name, form.email, form.password)
  end
end
