class ConflictError < ApplicationError
  def default_code
    ErrorCodes.code(:CONFLICT)
  end

  def default_message
    "Conflict"
  end
end
