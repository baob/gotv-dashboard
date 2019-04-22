Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'work_spaces#choose_council'

  resources :work_spaces, only: [:new, :create, :show] do
    resources :turnout_observations, only: [:new, :create]
  end
  resources :turnout_observations, only: [:show]
end
