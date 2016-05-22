Rails.application.routes.draw do
  resources :collaborators, only: :index
end
