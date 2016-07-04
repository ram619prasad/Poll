require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :posts

      resources :users do
        collection do
          post :login
          delete :logout
          post :sign_up
        end
      end
 
      resources :events do
        member do
          put :upvote
          put :downvote
          put :participant_response
          put :approve_event
        end
        collection do
          get :timeline
          get :attending_events
          get :interested_events
        end
      end

      resources :locations do
        collection do
          get :search
        end
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
