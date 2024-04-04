Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/shop", to: "products#index"

    get "/products/:id", to: "products#show", as: "product"
    get "/products/:id/details", to: "products#details", as: "product_details"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#logout"

    namespace :admin do
      root "dashboard#home"
    end
  end
end
