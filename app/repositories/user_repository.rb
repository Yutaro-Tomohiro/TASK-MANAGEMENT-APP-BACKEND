class UserRepository
  def create(name, email, password)
    ActiveRecord::Base.transaction do
      user = User.create!(identity: SecureRandom.uuid, name: name)
      Credential.create!(user: user, email: email, password: password)
    end

    true

    rescue ActiveRecord::ActiveRecordError
    raise InternalServerError
  end

  def find_by_email(email)
    Credential.find_by(email: email)
  end
end
