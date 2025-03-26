class UserRepository
  include UserRepositoryInterface

  def create(name, email, password)
    ActiveRecord::Base.transaction do
      user = User.create!(identity: SecureRandom.uuid, name: name)
      Credential.create!(user: user, email: email, password: password)
      user
    end
  end

  def find_by_email(email)
    Credential.find_by(email: email)
  end

  def authenticate_user(email, password)
    credential = Credential.find_by(email: email)
    credential&.authenticate(password) ? credential.user : nil
  end
end
