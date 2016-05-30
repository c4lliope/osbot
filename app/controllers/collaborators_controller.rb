class CollaboratorsController < ApplicationController
  def index
    @contributors = Repo.new("thoughtbot/administrate").contributors
  end
end
