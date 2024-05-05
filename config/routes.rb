Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/shop", to: "products#index"

    get "/products/:id", to: "products#show", as: "product"
    get "/products/:id/details", to: "products#details", as: "product_details"

    get "/search/products", to: "filters#search", as: "search"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#logout"

    namespace :admin do
      root "dashboard#index"

      resources :users, only: %i(index update)

      resources :orders, only: %i(index update delete)

      resources :products, only: %i(index new)
    end

    get "/carts", to: "carts#index"
    get "carts/count", to: "carts#count_cart_items"
    post "/carts", to: "carts#create"
    patch "/carts/:product_detail_id", to: "carts#update", as: "update_cart_item"
    delete "/carts/:product_detail_id", to: "carts#destroy", as: "delete_cart_item"

    resources :bills, only: %i(new create update) do
      member do
        get :repurchase, to: "repurchase#create"

        get "/reviews/products/:product_detail_id", to: "reviews#show", as: "load_review"
        post "/reviews", to: "reviews#create", as: "create_review"
      end
    end

    resources :histories, only: %i(index show)
  end
end
