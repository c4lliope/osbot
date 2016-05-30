require "rails_helper"

describe Contributor do
  include GithubApiHelpers

  describe "#score" do
    it "weighs recent contributions more heavily than older contributions" do
      newer = Contributor.new(pulls: [stub_contribution(created_at: 1.day.ago)])
      older = Contributor.new(pulls: [stub_contribution(created_at: 2.day.ago)])

      expect(newer.score).to be > older.score
    end

    it "weighs different contributions according to their value" do
      pull = Contributor.new(pulls: [stub_contribution(handle: "pull_contributor")])
      issue = Contributor.new(issues: [stub_contribution(handle: "issue_contributor")])
      pull_comment = Contributor.new(pull_comments: [stub_contribution(handle: "pull_comment_contributor")])
      issue_comment = Contributor.new(comments: [stub_contribution(handle: "issue_comment_contributor")])

      expect(pull.score).to be > issue.score
      expect(issue.score).to be > pull_comment.score
      expect(pull_comment.score).to be > issue_comment.score
    end
  end
end
