module JwtServiceInterface
  # :nocov:

  #
  # JWT を生成する
  #
  # @param [User]　_user User オブジェクト
  #
  # @return [String] 生成されたJWTトークン
  #
  def generate_jwt(_user)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  # :nocov:
end
