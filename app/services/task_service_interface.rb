module TaskServiceInterface
  # :nocov:

  #
  # 初期化処理
  #
  # @params [TaskRepository]　_task_repository タスク情報を操作するリポジトリ
  #
  def initialize(_user_repository)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  #
  # タスク作成処理
  #
  # @param [UserRegistrationForm]　_form タスク作成フォーム

  # @raise [BadRequestError] フォームが無効な場合
  #
  # @return [Array<User>] 作成されたタスクに紐づけられたユーザーの配列
  #
  def create_task(_form)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  #
  # タスク検索処理
  #
  # @param [TaskForm] _form タスク検索フォーム
  #
  # @raise [BadRequestError] フォームが無効な場合
  #
  # @return [Task] 検索されたタスク
  #
  def find_task(_form)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  # :nocov:
end
