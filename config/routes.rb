Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true do
      member do
        patch 'mark_best', as: :mark_best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
  resources :votes, only: %i[create destroy]
  resources :comments, only: :create

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
