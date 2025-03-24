module ErrorCodes
  CODES = {
    BAD_REQUEST: 400,
    UNAUTHORIZED: 401,
    NOT_FOUND: 404,
    CONFLICT: 409,
    INTERNAL_SERVER_ERROR: 500
  }.freeze

  def self.code(name)
    CODES[name] || CODES[:INTERNAL_SERVER_ERROR] # 未定義なら500を返す
  end
end
