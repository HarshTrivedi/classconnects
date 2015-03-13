Rails.application.routes.draw do
  get 'landings/index'

  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords", omniauth_callbacks: "users/omniauth_callbacks"}, skip: [:sessions, :registrations]
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'landings#index'

  get 'colleges/:id/content'  => 'college#show_content'         , as: :college_content
  get 'colleges/:id/peers'    => 'college#show_peers'           , as: :college_peers
  get 'colleges/:id/courses'  => 'college#show_courses'         , as: :college_courses
  get 'colleges/:id/discuss'  => 'college#show_discussion'      , as: :college_discussion


  get 'courses/:id/content'  => 'courses#show_content'          , as: :course_content
  get 'courses/:id/peers'    => 'courses#show_peers'            , as: :course_peers
  get 'courses/:id/discuss'  => 'courses#show_discussion'       , as: :course_discussion


  get 'buckets/:id/content'  => 'buckets#show_content'          , as: :bucket_content
  get 'buckets/:id/details'  => 'buckets#show_details'          , as: :bucket_details
  get 'buckets/:id/edit_details'  => 'buckets#edit_details'     , as: :edit_bucket_details
  put 'buckets/:id'          => 'buckets#update_details'        , as: :update_bucket_details  


  get 'folders/:id/content'       => 'folders#show_content'     , as: :folder_content
  get 'folders/:id/details'       => 'folders#show_details'     , as: :folder_details
  get 'folders/:id/edit_details'  => 'folders#edit_details'     , as: :edit_folder_details
  put 'folders/:id'               => 'folders#update_details'   , as: :update_folder_details  


  get 'files/:id/details'       => 'files#show_details'         , as: :file_details
  get 'files/:id/edit_details'  => 'files#edit_details'         , as: :edit_file_details
  put 'files/:id'               => 'files#update_details'       , as: :update_file_details  


  get '/my_uploads'             => 'profiles#uploads'                   , as: :uploads
  get '/my_downloads'           => 'profiles#downloads'                 , as: :downloads
  get '/profile'                => 'profiles#profile'                   , as: :profile
  get '/enrolled_courses'       => 'profiles#enrolled_courses'          , as: :enrolled_courses
  get '/favorite_courses'       => 'profiles#favorite_courses'          , as: :favorite_courses

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  
  #->Prelang (user_login:devise/stylized_paths)
  devise_scope :user do
    get    "login"   => "users/sessions#new",         as: :new_user_session
    post   "login"   => "users/sessions#create",      as: :user_session
    delete "signout" => "users/sessions#destroy",     as: :destroy_user_session
    
    get    "signup"  => "users/registrations#new",    as: :new_user_registration
    post   "signup"  => "users/registrations#create", as: :user_registration
    put    "signup"  => "users/registrations#update", as: :update_user_registration
    get    "account" => "users/registrations#edit",   as: :edit_user_registration
  end

end
