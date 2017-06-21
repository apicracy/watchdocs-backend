Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'sessions',
               registrations: 'registrations'
             }

  devise_scope :user do
    post '/signup', to: 'registrations#create'
  end

  post '/auth/slack/callback', to: 'notifications/slack#callback'

  namespace :api do
    namespace :v1 do
      post '/endpoint_schemas', to: 'endpoint_schemas#create'

      resources :projects do
        member do
          get :documentation
        end
      end
      resources :documents
      resources :groups
      resources :responses
      resources :endpoints do
        resource :request
      end
      resources :url_params, only: [:create, :update, :destroy]
      resources :headers, only: [:create, :update, :destroy]
      resources :users, only: [] do
        collection do
          get :me
        end
      end
      namespace :users do
        resources :reset_password_token, only: [:create]
      end
    end
  end
end
