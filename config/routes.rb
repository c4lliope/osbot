Rails.application.routes.draw do
  get "/gh/:organization/:repo_name/", to: "contributors#index"
end
