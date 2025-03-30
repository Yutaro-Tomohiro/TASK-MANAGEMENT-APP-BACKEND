module JwtServiceInterface
  # :nocov:

  #
  # JWTトークンをデコードする
  #
  # @param [String] _token デコード対象のJWTトークン
  #
  # @raise [JWT::DecodeError] トークンが無効な場合
  # @raise [JWT::ExpiredSignature] トークンの有効期限が切れている場合
  #
  # @return [Array<Hash>] デコードされたペイロードとヘッダー
  #
  def self.decode_jwt(_token)
    fail NotImplementedError, "You mast implement #{self}##{__method__}"
  end

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
