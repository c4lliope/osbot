class ReposController < ApplicationController
  before_action :ensure_authenticated

  # This action is currently only used to display the current user's information
  # as pulled from GitHub during OAuth.
  def index
  end
end
