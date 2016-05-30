module GithubApiHelpers
  def stub_contribution(handle: "foobar", created_at: 1.day.ago)
    double(
      attrs: {
        created_at: created_at,
        user: double(attrs: { login: handle }),
      }
    )
  end

  def stub_github_data(attributes = {})
    default_attributes = {
      issues: [],
      issues_comments: [],
      pulls: [],
      pulls_comments: [],
      login: true,
      collabs: [],
    }

    fake_github_client = double(default_attributes.merge(attributes))
    allow(Octokit::Client).to receive(:new).and_return(fake_github_client)

    fake_github_client
  end

  def stub_collaborator(handle: "foobar", admin: false, push: false, pull: true)
    double(
      attrs: {
        login: handle,
        permissions: double(
          attrs: {
            admin: admin,
            push: push,
            pull: pull,
          }
        ),
      }
    )
  end
end
