module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  private

  def authenticate_user!
    # TODO: ActionController::Cookiesへの依存を解消する方法を検討したい
    token = cookies.signed[:jwt]

    raise UnauthorizedError.new unless token

    begin
      payload = JwtService.decode_jwt(token).first

      if @current_user.nil? || @current_user.user_id != payload['user_id']
        @current_user = User.find_by(identity: payload['user_id'])
      end
      raise UnauthorizedError.new unless @current_user
    rescue JWT::DecodeError
      raise UnauthorizedError.new
    end
  end
end
