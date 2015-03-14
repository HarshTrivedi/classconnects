Rails.application.routes.draw do
  get 'landings/index'

  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords", omniauth_callbacks: "users/omniauth_callbacks"}, skip: [:sessions, :registrations]
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'landings#index'

  get 'colleges/:id/content'  => 'colleges#show_content'         , as: :college_content
  # get 'colleges/:id/peers'    => 'colleges#show_peers'           , as: :college_peers
  get 'colleges/:id/users'    => 'colleges#show_users'           , as: :college_users
  get 'colleges/:id/courses'  => 'colleges#show_courses'         , as: :college_courses
  get 'colleges/:id/discuss'  => 'colleges#show_discussion'      , as: :college_discussion


  get 'courses/:id/content'  => 'courses#show_content'          , as: :course_content
  # get 'courses/:id/peers'    => 'courses#show_peers'            , as: :course_peers
  get 'courses/:id/users'    => 'courses#show_users'            , as: :course_users
  get 'courses/:id/discuss'  => 'courses#show_discussion'       , as: :course_discussion


  get 'buckets/:id/content'  => 'buckets#show_content'          , as: :bucket_content
  get 'buckets/:id/details'  => 'buckets#show_details'          , as: :bucket_details
  get 'buckets/:id/edit_details'  => 'buckets#edit_details'     , as: :edit_bucket_details
  patch 'buckets/:id'          => 'buckets#update_details'        , as: :update_bucket_details  


  get 'folders/:id/content'       => 'folders#show_content'     , as: :folder_content
  get 'folders/:id/details'       => 'folders#show_details'     , as: :folder_details
  get 'folders/:id/edit_details'  => 'folders#edit_details'     , as: :edit_folder_details
  patch 'folders/:id'               => 'folders#update_details'   , as: :update_folder_details  


  get 'documents/:id/details'       => 'documents#show_details'         , as: :documents_details
  get 'documents/:id/edit_details'  => 'documents#edit_details'         , as: :edit_documents_details
  patch 'documents/:id'               => 'documents#update_details'       , as: :update_documents_details  


  get '/my_uploads'             => 'user_details#uploads'                   , as: :uploads
  get '/my_downloads'           => 'user_details#downloads'                 , as: :downloads
  get '/profile'                => 'user_details#profile'                   , as: :profile
  get '/enrolled_courses'       => 'user_details#enrolled_courses'          , as: :enrolled_courses
  get '/favorite_courses'       => 'user_details#favorite_courses'          , as: :favorite_courses
  get '/my_college'             => 'user_details#my_college'                , as: :my_college

  get  '/enrollment'                  => 'user_details#new_college_branch_enrollment'           , as: :new_college_branch_enrollment
  post '/enrollment'                  => 'user_details#create_college_branch_enrollment'        , as: :create_college_branch_enrollment
  post '/favorite'                    => 'user_details#create_favorite_course'                  , as: :create_favorite_course
  post '/download_bucket/:bucket_id'  => 'user_details#download_bucket'                         , as: :download_bucket
  post '/upload_bucket/:bucket_id'    => 'user_details#upload_bucket'                           , as: :upload_bucket



  get '/'                       => 'landings#index'                         , as: :landing

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
