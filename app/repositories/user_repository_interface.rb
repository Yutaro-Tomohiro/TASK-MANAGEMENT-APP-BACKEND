module UserRepositoryInterface
  # :nocov:

  #
  # 引数の情報を元に、ユーザーを登録する
  #
  # @params [String] _name ユーザー名
  # @params [String] _email Eメール
  # @params [String] _password パスワード
  #
  # @return [User] 新しく登録された User オブジェクト
  #
  def create(_name, _email, _password)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  #
  # 引数の情報を元に、クレデンシャルを検索する
  #
  # @params [String] _email Eメール
  #
  # @return [Credential] 登録された Credential オブジェクト
  #
  def find_by_email(_email)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  #
  # 引数の情報を元に、ユーザーを検索する
  #
  # @params [String] _email Eメール
  # @params [String] _password パスワード
  #
  # @return [User, nil] 登録された User オブジェクト, 失敗またはメールアドレスが見つからなかった場合は nil
  #
  def authenticate_user(_email)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  # :nocov:
end
