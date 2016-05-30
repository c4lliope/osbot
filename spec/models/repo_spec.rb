require "rails_helper"

describe Repo do
  describe "#scores" do
    it "fetches pull requests from the repository" do
      handle = "foobar"
      stub_github_data(pulls: [stub_contribution(handle: handle)])
      repo = Repo.new("graysonwright/osbot")

      scores = repo.scores

      expect(scores[handle]).to be > 0
    end

    it "fetches issues from the repository" do
      handle = "foobar"
      stub_github_data(issues: [stub_contribution(handle: handle)])
      repo = Repo.new("graysonwright/osbot")

      scores = repo.scores

      expect(scores[handle]).to be > 0
    end

    it "fetches issue comments from the repository" do
      handle = "foobar"
      stub_github_data(issues_comments: [stub_contribution(handle: handle)])
      repo = Repo.new("graysonwright/osbot")

      scores = repo.scores

      expect(scores[handle]).to be > 0
    end

    it "fetches pull request comments from the repository" do
      handle = "foobar"
      stub_github_data(pulls_comments: [stub_contribution(handle: handle)])
      repo = Repo.new("graysonwright/osbot")

      scores = repo.scores

      expect(scores[handle]).to be > 0
    end

    it "does not list scores for people who haven't contributed" do
      stub_github_data
      repo = Repo.new("graysonwright/osbot")

      scores = repo.scores

      expect(scores["graysonwright"]).to be_nil
    end

    it "weighs recent contributions more heavily than older contributions" do
      stub_github_data(pulls: [
        stub_contribution(created_at: 1.day.ago, handle: "newer_contributor"),
        stub_contribution(created_at: 2.day.ago, handle: "older_contributor"),
      ])
      repo = Repo.new("graysonwright/osbot")

      scores = repo.scores

      expect(scores["newer_contributor"]).to be > scores["older_contributor"]
    end

    it "weighs different contributions according to their value" do
      stub_github_data(
        pulls: [stub_contribution(handle: "pull_contributor")],
        issues: [stub_contribution(handle: "issue_contributor")],
        pulls_comments: [stub_contribution(handle: "pull_comment_contributor")],
        issues_comments: [stub_contribution(handle: "issue_comment_contributor")],
      )
      repo = Repo.new("graysonwright/osbot")

      scores = repo.scores

      expect(scores["pull_contributor"]).to be > scores["issue_contributor"]
      expect(scores["issue_contributor"]).to be > scores["pull_comment_contributor"]
      expect(scores["pull_comment_contributor"]).to be > scores["issue_comment_contributor"]
    end

    def stub_github_data(attributes = {})
      default_attributes = {
        issues: [],
        issues_comments: [],
        pulls: [],
        pulls_comments: [],
        login: true,
      }

      fake_github_client = double(default_attributes.merge(attributes))
      allow(Octokit::Client).to receive(:new).and_return(fake_github_client)

      fake_github_client
    end

    def stub_contribution(handle: "foobar", created_at: 1.day.ago)
      double(
        attrs: {
          created_at: created_at,
          user: double(attrs: { login: handle }),
        }
      )
    end
  end
end
