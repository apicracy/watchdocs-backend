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

      resources :projects
      resources :endpoints
      resources :users, only: [] do
        collection do
          get :me
        end
      end
    end
  end
end
