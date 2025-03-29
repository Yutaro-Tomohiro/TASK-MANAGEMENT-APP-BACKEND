module TaskRepositoryInterface
  # :nocov:

  #
  # タスクを作成し、指定されたユーザーに関連付ける
  #
  # @param [Array<String>] _assignee_ids ユーザーの identity の配列
  # @param [String] _title タイトル
  # @param [String] _priority 優先度度
  # @param [String] _status ステータス
  # @param [DateTime] _begins_at 開始日時
  # @param [DateTime] _ends_at 終了日時
  # @param [String, nil] _text 説明
  #
  # @raise [NotFoundError] ユーザーが見つからない場合
  #
  #  @return [Array<User>] タスクに紐づけられたユーザーの配列
  #
  def create(_assignee_ids, _title, _priority, _status, _begins_at, _ends_at, _text)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  #
  # タスクをフィルタリングする
  #
  # @param [String, nil] _assignee_id ユーザーの identity
  # @param [String, nil] _status ステータス
  # @param [String, nil] _priority 優先度
  # @param [String, nil] _expires 期限
  #
  # @raise [NotFoundError] タスクが見つからない場合
  #
  # @return [Array<Task>] フィルタリングされたタスクの配列
  #
  def filter(_assignee_id = nil, _status = nil, _priority = nil)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  # :nocov:

  #
  # タスクを検索する
  #
  # @param [String] _identity タスクの identity
  #
  # @raise [NotFoundError] タスクが見つからない場合
  #
  # @return [Task] タスク
  #
  def find(_identity)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  #
  # タスクを更新する
  #
  # @param [Array<String>] _assignee_ids ユーザーの identity の配列
  # @param [String] _title タイトル
  # @param [String] _priority 優先度度
  # @param [String] _status ステータス
  # @param [DateTime] _begins_at 開始日時
  # @param [DateTime] _ends_at 終了日時
  # @param [String, nil] _text 説明
  # @param [String] _identity タスクの identity
  #
  # @raise [NotFoundError] タスクが見つからない場合
  # @raise [NotFoundError] ユーザーが見つからない場合
  #
  # @return [Task] 更新されたタスク
  #
  def update(_assignee_ids, _title, _priority, _status, _begins_at, _ends_at, _text, _identity)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  #
  # タスクを削除する
  #
  # @param [String] _identity タスクの identity
  #
  # @raise [NotFoundError] タスクが見つからない場合
  #
  # @return [Task] 削除されたタスク
  #
  def delete(_identity)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  # :nocov:
end
