Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/endpoint_schemas', to: 'endpoint_schemas#create'
    end
  end
end
