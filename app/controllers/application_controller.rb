class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user=(user)
    session[:user] = user.try(:to_session_hash)
  end

  def current_user
    if session[:user].present?
      User.build_from_session_hash(session[:user])
    end
  end

  def ensure_authenticated
    unless current_user
      redirect_to new_session_path
    end
  end
end
