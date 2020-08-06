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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
