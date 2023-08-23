Rails.application.routes.draw do


  get 'users/index'
  devise_for :users
  get 'pages/home'
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
 end

  root to: redirect('/home')
  get 'home', to: 'pages#home', as: 'home'
  get 'about', to: 'pages#about', as: 'about'
  
  get "/clients/new", to: "clients#new"
  get 'clients', to: 'clients#index'
  get 'clients/:id/edit', to: 'clients#edit', as: 'edit_client'
  get 'global_moderator_index', to: 'clients#global_moderator_index'
  
  get 'users', to:'users#index'
  get 'combined', to: 'clients#combined'

  get 'clinicians', to:'clinicians#index'

  get "/clinicians/new", to: "clinicians#new", as: 'new_clinician'
  get 'clinicians/:id/edit', to: 'clinicians#edit', as: 'edit_clinician'
  

  resources :users, only: [:index, :new, :create]

  resources :clients do
    resources :emergency_contacts, only: [:create, :destroy, :new, :edit, :update]
    resources :dwt_tests do
      collection do
        get 'new_dwt_list1', to: 'dwt_tests#new_dwt_list1', as: 'dwt_list1'
        get 'new_dwt_list2', to: 'dwt_tests#new_dwt_list2', as: 'dwt_list2'
        get 'new_dwt_list3', to: 'dwt_tests#new_dwt_list3', as: 'dwt_list3'
        get 'new_dwt_list4', to: 'dwt_tests#new_dwt_list4', as: 'dwt_list4'
        get 'new_dnw_list1', to: 'dnw_tests#new_dnw_list1', as: 'dnw_list1'
        get 'new_dnw_list2', to: 'dnw_tests#new_dnw_list2', as: 'dnw_list2'
        get 'new_dnw_list3', to: 'dnw_tests#new_dnw_list3', as: 'dnw_list3'
        get 'new_dnw_list4', to: 'dnw_tests#new_dnw_list4', as: 'dnw_list4'
        get 'new_rddt_list1', to: 'rddt_tests#new_rddt_list1', as: 'rddt_list1'
        get 'new_rddt_list2', to: 'rddt_tests#new_rddt_list2', as: 'rddt_list2'
      end
    end
  end

end
