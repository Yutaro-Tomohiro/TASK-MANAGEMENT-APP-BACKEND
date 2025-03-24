class BadRequestError < ApplicationError
  def default_code
    ErrorCodes.code(:BAD_REQUEST)
  end

  def default_message
    'Bad Request'
  end
end
