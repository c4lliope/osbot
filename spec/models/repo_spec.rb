require "rails_helper"

describe Repo do
  include GithubApiHelpers

  describe "#contributors" do
    it "returns a list of contributors to the repo" do
      client = fake_github_client(pulls: [stub_contribution(handle: "foobar")])
      repo = Repo.new("graysonwright/osbot", client)

      contributors = repo.contributors

      expect(contributors.first.handle).to eq("foobar")
    end

    it "assigns the permissions from the repository to the contributors" do
      handle = "foobar"
      collaborator_info = stub_collaborator(
        handle: handle,
        admin: true,
        push: true,
        pull: true
      )
      client = fake_github_client(
        collabs: [collaborator_info],
        pulls: [stub_contribution(handle: handle)],
      )
      repo = Repo.new("graysonwright/osbot", client)

      contributor = repo.contributors.first

      expect(contributor.admin_permissions?).to be_truthy
      expect(contributor.push_permissions?).to be_truthy
      expect(contributor.pull_permissions?).to be_truthy
    end

    it "assigns pull requests from the repository to their author" do
      handle = "foobar"
      client = fake_github_client(pulls: [stub_contribution(handle: handle)])
      repo = Repo.new("graysonwright/osbot", client)

      contributor = repo.contributors.first

      expect(contributor.handle).to eq(handle)
      expect(contributor.score).to be > 0
    end

    it "assigns issues from the repository to their author" do
      handle = "foobar"
      client = fake_github_client(issues: [stub_contribution(handle: handle)])
      repo = Repo.new("graysonwright/osbot", client)

      contributor = repo.contributors.first

      expect(contributor.handle).to eq(handle)
      expect(contributor.score).to be > 0
    end

    it "assigns issue comments from the repository to their author" do
      handle = "foobar"
      client = fake_github_client(
        issues_comments: [stub_contribution(handle: handle)],
      )
      repo = Repo.new("graysonwright/osbot", client)

      contributor = repo.contributors.first

      expect(contributor.handle).to eq(handle)
      expect(contributor.score).to be > 0
    end

    it "assigns pull request comments from the repository to their author" do
      handle = "foobar"
      client = fake_github_client(
        pulls_comments: [stub_contribution(handle: handle)],
      )
      repo = Repo.new("graysonwright/osbot", client)

      contributor = repo.contributors.first

      expect(contributor.handle).to eq(handle)
      expect(contributor.score).to be > 0
    end

    it "excludes people who have access to the repo but haven't contributed"
  end
end
