Rails.application.routes.draw do
  resources :products

  root "sessions#new"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get :sign_in, to: "sessions#new"
  post :sign_in, to: "sessions#create"
  get :sign_out, to: "sesssions#destroy"
end
