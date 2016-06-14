module GithubApiHelpers
  def stub_contribution(handle: "foobar", created_at: 1.day.ago)
    double(
      attrs: {
        created_at: created_at,
        user: double(attrs: { login: handle }),
      }
    )
  end

  def fake_github_client(attributes = {})
    default_attributes = {
      issues: [],
      issues_comments: [],
      pulls: [],
      pulls_comments: [],
      login: true,
      collabs: [],
    }

    double(default_attributes.merge(attributes))
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
