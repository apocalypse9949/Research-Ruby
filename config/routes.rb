Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_for :users
      resources :uploads, only: [:index, :create, :show]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
