class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_page
  # rescue_from ActionController::UnknownFormat, with: :invalid_page
  # rescue_from ActionController::RoutingError, with: :invalid_page
  # rescue_from ActionController::UnknownController, with: :invalid_page

  def invalid_page
    render '/template/invalid.html.erb', layout: false
  end
end
