class CollaboratorsController < ApplicationController
  def index
    @scores = Repo.new("thoughtbot/administrate").scores
  end
end
