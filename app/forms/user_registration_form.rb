class UserRegistrationForm
  include ActiveModel::Model

  attr_accessor :name, :email, :password

  validates :name, presence: true, length: { maximum: 50, message: "name error" }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "email error" }
  validates :password, presence: true, length: { in: 8..24, message: "password error" }
end
