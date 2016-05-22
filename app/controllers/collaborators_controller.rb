require "github"

class CollaboratorsController < ApplicationController
  def index
    @scores = Github.new.scores
  end
end
