module UserAuthenticationServiceInterface
  # :nocov:

  #
  # 初期化処理
  #
  # @params [UserRepository]　_user_repository ユーザー情報を操作するリポジトリ
  # @params [JwtService]　_jwt_service JWTを生成するサービス
  #
  def initialize(_user_repository, _jwt_service)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  #
  # ユーザーログイン処理
  #
  # @param [UserRegistrationForm]　_form ユーザーログインフォーム
  #
  #  @return [{ user: Object, token: String }] 認証されたユーザー情報とJWTトークン
  #
  def register_user(_form)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  # :nocov:
end
