class ContributorsController < ApplicationController
  def index
    repo_path = [params[:organization], params[:repo_name]].join("/")
    @repo = Repo.new(repo_path)
  end
end
