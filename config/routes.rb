Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions do
    resources :answers, only: [:new, :create, :show]
  end
end
