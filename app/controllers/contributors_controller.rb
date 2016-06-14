class ContributorsController < ApplicationController
  before_filter :ensure_authenticated

  def index
    repo_path = [params[:organization], params[:repo_name]].join("/")
    @repo = Repo.new(repo_path, github_client)
  end

  private

  def github_client
    Octokit.auto_paginate = true
    client = Octokit::Client.new(access_token: current_user.token)
    client.login
    client
  end
end
