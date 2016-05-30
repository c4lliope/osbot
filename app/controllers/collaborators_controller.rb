class CollaboratorsController < ApplicationController
  def index
    @repo = Repo.new("thoughtbot/administrate")
  end
end
