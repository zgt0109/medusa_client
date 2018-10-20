Rails.application.routes.draw do
  resources :products
  resources :tags
  resources :tag_attachments

  root "sessions#new"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
