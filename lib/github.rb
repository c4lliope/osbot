class Github
  BLACKLISTED_USERS = %w[
    houndci-bot
  ]

  def scores
    cache("cache/scores.yml") do
      contributors.
        map { |handle| [handle, score_for_user(handle)] }.
        reject { |_, score| score.zero?  }.
        sort_by { |_, score| score }.
        reverse.
        to_h
    end
  end

  private

  def contributors
    [
      comments_by_user,
      issues_by_user,
      pulls_by_user,
      pull_comments_by_user,
    ].map(&:keys).flatten.uniq - BLACKLISTED_USERS
  end

  def score_for_user(handle)
    1_000_000 * (
      10 * score_for_contributions(pulls_by_user[handle] || []) +
      1 * score_for_contributions(comments_by_user[handle] || []) +
      3 * score_for_contributions(issues_by_user[handle] || []) +
      5 * score_for_contributions(pull_comments_by_user[handle] || [])
    )
  end

  def score_for_contributions(contribution_collection)
    contribution_collection.sum do |contribution|
      time_since_contribution = Time.current - contribution.attrs[:created_at]
      1.0 / time_since_contribution
    end
  end

  def pulls_by_user
    @pulls_by_user ||= pulls.group_by { |pull| pull.attrs[:user].attrs[:login] }
  end

  def issues_by_user
    @issues_by_user ||= issues.group_by { |issue| issue.attrs[:user].attrs[:login] }
  end

  def comments_by_user
    @comments_by_user ||= comments.group_by { |comment| comment.attrs[:user].attrs[:login] }
  end

  def pull_comments_by_user
    @pull_comments_by_user ||= pull_comments.group_by { |pull_comment| pull_comment.attrs[:user].attrs[:login] }
  end

  def comments
    cache("cache/github/issues_comments.yml") do
       client.issues_comments("thoughtbot/administrate")
    end
  end

  def issues
    cache("cache/github/issues.yml") do
      client.issues("thoughtbot/administrate")
    end
  end

  def pulls
    cache("cache/github/pulls.yml") do
      client.pulls("thoughtbot/administrate")
    end
  end

  def pull_comments
    cache("cache/github/pull_comments.yml") do
      client.pulls_comments("thoughtbot/administrate")
    end
  end

  def cache(cache_file)
    if File.exists?(cache_file)
      puts "CACHE: Hit, reading from #{cache_file}"
      result = YAML.parse(File.read(cache_file)).to_ruby
    else
      puts "CACHE: Miss, #{cache_file} does not exist"
      result = yield
      puts "CACHE: Writing repsonse to #{cache_file}"
      File.write(cache_file, result.to_yaml)
    end

    result
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
