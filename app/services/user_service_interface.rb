module UserServiceInterface
  # :nocov:

  #
  # 初期化処理
  #
  # @params [UserRepository]　_user_repository ユーザー情報を操作するリポジトリ
  #
  def initialize(_user_repository)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  #
  # ユーザー登録処理
  #
  # @param [UserRegistrationForm]　_form ユーザー登録フォーム
  #
  # @raise [BadRequestError] フォームが無効な場合
  # @raise [ConflictError] メールアドレスがすでに存在する場合
  #
  # @return [User] 登録された User オブジェクト
  #
  def register_user(_form)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  # :nocov:
end
