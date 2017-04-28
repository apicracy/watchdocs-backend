Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             },
             controllers: {
               sessions: 'api/v1/sessions'
             }

  namespace :api do
    namespace :v1 do
      post '/endpoint_schemas', to: 'endpoint_schemas#create'

      resources :projects do
        member do
          get :documentation
        end
      end
      resources :documents
      resources :responses
      resources :endpoints do
        resource :request
      end
      resources :url_params, only: [:create, :update, :destroy]
      resources :users, only: [] do
        collection do
          get :me
        end
      end
    end
  end
end
