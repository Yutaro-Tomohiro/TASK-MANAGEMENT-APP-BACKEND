class JwtService
  include JwtServiceInterface

  SECRET_KEY = Rails.application.credentials.secret_key_base
  ALGORITHM = 'HS256'

  def generate_jwt(user_id)
    payload = {
      user_id: user_id,
      exp: 2.hours.from_now.to_i
    }
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end
end
