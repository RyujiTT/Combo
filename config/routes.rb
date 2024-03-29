Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: [:index, :edit, :update, :show]
    resources :groups, only: [:index, :show, :destroy] do
      resource :group_users, only: [:show, :destroy]
    end
    resources :posts, only: [:show, :destroy]
    get "search" => "searches#search"
    get "groups/:id/members" => "groups#members", as: :members
  end
  # 顧客用
  # URL /customers/sign_in ...
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  scope module: :public do
    resources :posts, only: [:index, :show, :edit, :destroy, :update] do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
    get 'users/:id/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
    # 退会処理用のルーティング
    patch 'users/:id/withdrawal' => 'users#withdrawal', as: 'withdrawal'
    resources :users, only: [:show, :edit, :update]
    resources :groups, only: [:new, :index, :show, :create, :edit, :update, :destroy] do
      resource :group_users, only: [:show, :create, :destroy]
      resource :permits, only: [:create, :destroy]
      resources :posts, only: [:create]
    end
    get "groups/:id/search" => "searches#search", as: :search
    get "groups/:id/members" => "groups#members", as: :members
    get "groups/:id/permits" => "groups#permits", as: :permits
  end

  root to: 'public/homes#top'
  get 'about' => 'public/homes#about', as: 'about'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
