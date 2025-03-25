class UserLoginForm
  include ActiveModel::Model

  attr_accessor :email, :password

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { in: 8..24 }
end
