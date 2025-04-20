# frozen_string_literal: true

# :nocov:
class ApiError < StandardError
  def status_code
    raise NotImplementedError
  end
end

class NotFoundError < ApiError
  def status_code
    404
  end
end

class BadRequestError < ApiError
  def status_code
    400
  end
end
# :nocov:
