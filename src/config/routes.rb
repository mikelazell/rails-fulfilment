Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "orders#index"
  get "/orders", to: "orders#index"  
  get "/orders/new", to: "orders#new"
  get "/orders/:id", to: "orders#detail"
  post "/orders", to: "orders#create"

  get "/orders/:id/setstatus/:status", to: "orders#set_status"
end
