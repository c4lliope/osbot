class SessionsController < ApplicationController
  def create
    self.current_user = User.build_from_auth_hash(auth_hash)
    redirect_to repos_path
  end

  def new
  end

  def destroy
    self.current_user = nil
    redirect_to new_session_path
  end

  protected

  def auth_hash
    request.env["omniauth.auth"]
  end
end
