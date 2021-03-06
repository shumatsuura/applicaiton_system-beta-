Rails.application.routes.draw do
  root 'pre_applications#landing'

  resources :pre_applications
  resources :approvals
  resources :reports
  resources :remote_works

  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'
    }
  resources :users, only:[:index]

  namespace :admin do
    resources :users
    resources :pre_applications, only:[:show,:index,:update,:edit,:destroy]
    resources :approvals
  #   resources :users do
  #     collection do
  #       get :dashboard
  #     end
  #   end
  #
  #   resources :pre_applications, only:[] do
  #     collection do
  #       get :index_all
  #     end
  #   end
  end
end
