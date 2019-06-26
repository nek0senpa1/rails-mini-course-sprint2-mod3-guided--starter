class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def authenticate_user!
    api_key = request.headers["HTTP_API_KEY"]
    @current_user = User.find_by!(api_key: api_key)
  end

  def current_user
    @current_user
  end

  def forbidden
    render json: { error: "Forbidden", message: "You are not authorized to do this" }, status: :forbidden
  end

  def not_found_error
    render json: { error: "Not Found", message: "Cound not find record" }, status: :not_found
  end
end
