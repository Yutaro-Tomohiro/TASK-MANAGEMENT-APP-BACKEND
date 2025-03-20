class UserRepository
  def create(name, email, password)
    ActiveRecord::Base.transaction do
      user = User.create!(identity: SecureRandom.uuid, name: name)
      Credential.create!(user: user, email: email, password: password)
    end

    true
  end
end
