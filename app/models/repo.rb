class Repo
  BLACKLISTED_USERS = %w[
    houndci-bot
  ].freeze

  def initialize(repo_path)
    @repo_path = repo_path
  end

  attr_reader :repo_path

  def contributors
    github_contributors.map do |handle|
      Contributor.new(
        handle: handle,
        pulls: pulls_by_user[handle] || [],
        issues: issues_by_user[handle] || [],
        pull_comments: pull_comments_by_user[handle] || [],
        comments: comments_by_user[handle] || [],
      )
    end.
    reject { |contributor| contributor.score.zero? }.
    sort_by(&:score).
    reverse
  end

  private

  def github_contributors
    [
      comments_by_user,
      issues_by_user,
      pulls_by_user,
      pull_comments_by_user,
    ].map(&:keys).flatten.uniq - BLACKLISTED_USERS
  end

  def pulls_by_user
    @pulls_by_user ||= group_by_user(pulls)
  end

  def issues_by_user
    @issues_by_user ||= group_by_user(issues)
  end

  def comments_by_user
    @comments_by_user ||= group_by_user(comments)
  end

  def pull_comments_by_user
    @pull_comments_by_user ||= group_by_user(pull_comments)
  end

  def group_by_user(contributions)
    contributions.group_by { |contrib| contrib.attrs[:user].attrs[:login] }
  end

  def comments
    cache("cache/github/issues_comments.yml") do
      client.issues_comments(repo_path)
    end
  end

  def issues
    cache("cache/github/issues.yml") do
      client.issues(repo_path)
    end
  end

  def pulls
    cache("cache/github/pulls.yml") do
      client.pulls(repo_path)
    end
  end

  def pull_comments
    cache("cache/github/pull_comments.yml") do
      client.pulls_comments(repo_path)
    end
  end

  def cache(cache_file)
    if Rails.env.development?
      if File.exist?(cache_file)
        puts "CACHE: Hit, reading from #{cache_file}"
        YAML.parse(File.read(cache_file)).to_ruby
      else
        puts "CACHE: Miss, #{cache_file} does not exist"
        result = yield
        puts "CACHE: Writing repsonse to #{cache_file}"
        File.write(cache_file, result.to_yaml)
        result
      end
    else
      yield
    end
  end

  def client
    @client ||= begin
                  Octokit.auto_paginate = true
                  client = Octokit::Client.new(netrc: true)
                  client.login
                  client
                end
  end
end
