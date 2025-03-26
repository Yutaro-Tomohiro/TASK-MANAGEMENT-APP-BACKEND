class UnauthorizedError < ApplicationError
  def default_code
    ErrorCodes.code(:UNAUTHORIZED)
  end

  def default_message
    'Unauthorized'
  end
end
