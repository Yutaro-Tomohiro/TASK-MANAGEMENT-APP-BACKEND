module TaskRepositoryInterface
  # :nocov:

  #
  # タスクを作成し、指定されたユーザーに関連付ける
  #
  # @param [Array<Integer>] _assignee_ids ユーザーの identity の配列
  # @param [String] _title タイトル
  # @param [Integer] _priority 優先度
  # @param [String] _status ステータス
  # @param [DateTime] _begins_at 開始日時
  # @param [DateTime] _ends_at 終了日時
  # @param [String, nil] _text 説明
  # @raise [NotFoundError] ユーザーが見つからない場合
  #
  # @return [void]
  #
  def create(_assignee_ids, _title, _priority, _status, _begins_at, _ends_at, _text)
    fail NotImplementedError, "You mast implement #{self.class}##{__method__}"
  end

  # :nocov:
end
