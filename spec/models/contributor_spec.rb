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
      pull = Contributor.new(pulls: [stub_contribution(handle: "pull")])
      issue = Contributor.new(issues: [stub_contribution(handle: "issue")])
      pull_comment = Contributor.new(
        pull_comments: [stub_contribution(handle: "pull_comment")]
      )
      issue_comment = Contributor.new(
        comments: [stub_contribution(handle: "issue_comment")]
      )

      expect(pull.score).to be > issue.score
      expect(issue.score).to be > pull_comment.score
      expect(pull_comment.score).to be > issue_comment.score
    end
  end

  describe "#admin_permissions?" do
    it "reads the permissions from the collaborator object" do
      admin_info = stub_collaborator(admin: true)
      non_admin_info = stub_collaborator(admin: false)

      admin = Contributor.new(collaborator_info: admin_info)
      non_admin = Contributor.new(collaborator_info: non_admin_info)

      expect(admin.admin_permissions?).to be_truthy
      expect(non_admin.admin_permissions?).to be_falsey
    end

    it "defaults to false" do
      contributor = Contributor.new

      expect(contributor.admin_permissions?).to be_falsey
    end
  end

  describe "#pull_permissions?" do
    it "reads the permissions from the collaborator object" do
      puller_info = stub_collaborator(pull: true)
      non_puller_info = stub_collaborator(pull: false)

      puller = Contributor.new(collaborator_info: puller_info)
      non_puller = Contributor.new(collaborator_info: non_puller_info)

      expect(puller.pull_permissions?).to be_truthy
      expect(non_puller.pull_permissions?).to be_falsey
    end

    it "defaults to true" do
      contributor = Contributor.new

      expect(contributor.pull_permissions?).to be_truthy
    end
  end

  describe "#push_permissions?" do
    it "reads the permissions from the collaborator object" do
      pusher_info = stub_collaborator(push: true)
      non_pusher_info = stub_collaborator(push: false)

      pusher = Contributor.new(collaborator_info: pusher_info)
      non_pusher = Contributor.new(collaborator_info: non_pusher_info)

      expect(pusher.push_permissions?).to be_truthy
      expect(non_pusher.push_permissions?).to be_falsey
    end

    it "defaults to false" do
      contributor = Contributor.new

      expect(contributor.push_permissions?).to be_falsey
    end
  end
end
