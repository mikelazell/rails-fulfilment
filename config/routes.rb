Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "orders#index"
  get "/orders", to: "orders#index"  
  get "/orders/:id", to: "orders#show"
end
