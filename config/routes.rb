Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  scope '(:locale)', locale: /en|lt/ do
    resources :participants do
      collection do
        post :bulk_upload
      end
    end
    get 'user_error/index'
    get 'user_dashboard/index'
    resources :options_calculations do
      collection do
        get :remove_all
        get :verify_calculations
        get :ledger
        get :download_certificates
      end
    end
    resources :options_profiles
    resources :grant_rules
    resources :employee_data
    resources :fields
    resources :grant_types
    resources :valuations

    root to: redirect('/users/sign_in')
    get '/dashboard', to: 'pages#home'
    get '/participant/dashboard', to: 'user_dashboard#index'
    get '/participant/documents', to: 'user_dashboard#documents'
    get '/participant/calculated_options', to: 'user_dashboard#calculated_options'
    get '/participant/documents/download', to: 'user_dashboard#generate_docx', defaults: { format: :docx }
    get '/participant/error', to: 'user_error#index'
    get '/about', to: 'pages#about'
    post '/employee_data/import', to: 'employee_data#import'
    post '/options_profile_mapping/import', to: 'options_profile_maps#import'
    get '/options_profile_mapping/new', to: 'options_profile_maps#new'
    get '/options_profile_mapping/remove_all', to: 'options_profile_maps#remove_all'
    get '/docs/formula_reference', to: 'formula_reference#index'
    post '/options_calculations/calculate', to: 'options_calculations#calculate'
  end
end
