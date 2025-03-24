class ApplicationError < StandardError
  attr_reader :error_code

  def initialize(message = default_message, error_code = default_code)
    @error_code = error_code
    super(message)
  end

  def default_code
    ErrorCodes.code(:INTERNAL_SERVER_ERROR) # デフォルトのエラーコード（Internal Server Error）
  end

  def default_message
    "Internal Server Error"
  end

  def self.wrap(error)
    return error if error.is_a?(ApplicationError) # すでに ApplicationError ならそのまま

    # StandardError など他の例外をラップして ApplicationError として扱う
    new("Unhandled Error: #{error.message}")
  end
end
