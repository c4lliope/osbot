class Github
  def scores
    collabs.map do |handle|
      [
        handle,
        10 * user_pull_counts.fetch(handle, 0) +
        1 * user_comment_counts.fetch(handle, 0) +
        3 * user_pull_comment_counts.fetch(handle, 0) +
        5 * user_issue_counts.fetch(handle, 0)
      ]
    end.
    reject { |_, score| score.zero?  }.
    sort_by { |_, score| score }.
    reverse.to_h
  end

  def user_comment_counts
    @user_comment_counts ||= count_by_user(comments)
  end

  def user_issue_counts
    @user_issue_counts ||= count_by_user(issues)
  end

  def user_pull_counts
    @user_pull_counts ||= count_by_user(pulls)
  end

  def user_pull_comment_counts
    @user_pull_comment_counts ||= count_by_user(pull_comments)
  end

  def collabs
    # TODO revise this to include everyone who has contributed
    cache("cache/collaborators.yml") do
      client.collabs("thoughtbot/administrate")
    end.map {|c| c.attrs[:login] }
  end

  private

  def count_by_user(resources)
    resources.
      map {|c| c.attrs[:user].attrs[:login] }.
      group_by {|handle| handle}.
      transform_values {|v| v.count }
  end

  def comments
    cache("cache/issues_comments.yml") do
       client.issues_comments("thoughtbot/administrate")
    end
  end

  def issues
    cache("cache/issues.yml") do
      client.issues("thoughtbot/administrate")
    end
  end

  def pulls
    cache("cache/pulls.yml") do
      client.pulls("thoughtbot/administrate")
    end
  end

  def pull_comments
    cache("cache/pull_comments.yml") do
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
