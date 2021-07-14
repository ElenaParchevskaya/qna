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

  root to: 'questions#index'
end
