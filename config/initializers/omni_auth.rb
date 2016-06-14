OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :github,
    ENV.fetch("GITHUB_CLIENT_ID"),
    ENV.fetch("GITHUB_CLIENT_SECRET"),
    scope: "repo,user:email",
  )
end
