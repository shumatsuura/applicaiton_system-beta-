Rails.application.routes.draw do
  get 'reports/index'
  get 'approvals/index'
  root 'pre_applications#index'

  resources :pre_applications
  resources :approvals
  resources :reports

  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'
    }
  resources :users

  # namespace :admin do
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
  # end
end
