Rails.application.routes.draw do
  root 'pages#index'

  resources :users, only: %i[new create]

  resources :questions do
    resources :answers, only: %i[create destroy edit update]
  end
end
