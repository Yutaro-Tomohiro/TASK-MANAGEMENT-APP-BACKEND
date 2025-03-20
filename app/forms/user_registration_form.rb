class UserRegistrationForm
  include ActiveModel::Model

  attr_accessor :name, :email, :password
end
