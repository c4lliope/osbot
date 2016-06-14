Rails.application.routes.draw do
  get "/gh/:organization/:repo_name/", to: "contributors#index"
  get "/auth/github/callback", to: "sessions#create"
  resource :session, only: [:destroy, :create, :new]
  resources :repos, only: [:index]
end
