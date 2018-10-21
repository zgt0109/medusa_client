Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :products
  resources :tags
  resources :tag_attachments

  scope '/api' do
    resources :upgrades, only: [] do
      collection do
        get 'check'
        get 'download'
      end
    end
  end

  root "sessions#new"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
