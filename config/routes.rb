Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :users, except: [:destroy] do
        resources :transactions, only: [:index], module: :users do
          get "withdrawals", on: :collection
          get "deposits", on: :collection
          get "admin", on: :collection
        end
        post "transfer", on: :member
      end
    end
  end
end
