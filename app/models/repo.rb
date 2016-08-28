class Repo
  BLACKLISTED_USERS = %w[
    houndci-bot
  ].freeze

  def initialize(repo_path, github_client)
    @repo_path = repo_path
    @github_client = github_client
  end

  attr_reader :repo_path

  def contributors
    cache("contributors") do
      github_contributors.
        map(&method(:contributor_for_handle)).
        reject { |contributor| contributor.score.zero? }.
        sort_by(&:score).
        reverse
    end
  end

  def comments
    cache("github/issues_comments") do
      client.issues_comments(repo_path)
    end
  end

  def issues
    cache("github/issues") do
      client.issues(repo_path)
    end
  end

  def pulls
    cache("github/pulls") do
      client.pulls(repo_path)
    end
  end

  def pull_comments
    cache("github/pull_comments") do
      client.pulls_comments(repo_path)
    end
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

  def contributor_for_handle(handle)
    Contributor.new(
      handle: handle,
      collaborator_info: collaborator_with_handle(handle),
      pulls: pulls_by_user[handle] || [],
      issues: issues_by_user[handle] || [],
      pull_comments: pull_comments_by_user[handle] || [],
      comments: comments_by_user[handle] || [],
    )
  end

  def collaborators
    @collaborators ||= cache("github/collaborators") do
      client.collabs(repo_path)
    end
  end

  def collaborator_with_handle(handle)
    collaborators.detect { |collaborator| collaborator.attrs[:login] == handle }
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

  def cache(cache_name)
    cache_file = "cache/#{repo_path}/#{cache_name}.yml"
    FileUtils.mkdir_p(File.dirname(cache_file))

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
    @github_client
  end
end
