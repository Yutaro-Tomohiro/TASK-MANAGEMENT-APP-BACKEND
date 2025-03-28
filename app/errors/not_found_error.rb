class NotFoundError < ApplicationError
  def default_code
    ErrorCodes.code(:NOT_FOUND)
  end

  def default_message
    'Not Found'
  end
end
