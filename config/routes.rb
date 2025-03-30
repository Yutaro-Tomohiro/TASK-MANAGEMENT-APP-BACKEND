Rails.application.routes.draw do
  namespace :v1 do
    resources :users, only: [:create] do
      collection do
        post "login", to: "users#login"
      end
    end
  
    resources :tasks, only: [:create, :index, :show, :update, :destroy], param: :identity
  end
end
