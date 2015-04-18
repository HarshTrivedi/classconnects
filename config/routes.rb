require 'resque/server'
Rails.application.routes.draw do
  get 'landings/index'

  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords", omniauth_callbacks: "users/omniauth_callbacks"}, skip: [:sessions, :registrations]
  ActiveAdmin.routes(self)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'landings#index'

  get   'colleges/:id/content'  => 'colleges#show_content'         , as: :college_content
  post  'colleges/:id/content'  => 'colleges#show_content'         , as: :college_content_remote

  get 'colleges/:id/courses'    => 'colleges#show_courses'         , as: :college_courses
  post 'colleges/:id/courses'   => 'colleges#show_courses'         , as: :college_courses_remote
  
  get 'colleges/:id/users'    => 'colleges#show_users'           , as: :college_users
  post 'colleges/:id/users'    => 'colleges#show_users'           , as: :college_users_remote

  get 'colleges/:id/discuss'  => 'colleges#show_discussion'      , as: :college_discussion

  post 'pusher/auth', :to => "pusher#auth"

  get 'courses/:id/content'  => 'courses#show_content'          , as: :course_content
  post 'courses/:id/content'  => 'courses#show_content'          , as: :course_content_remote

  get 'courses/:id/users'    => 'courses#show_users'            , as: :course_users
  post 'courses/:id/users'    => 'courses#show_users'            , as: :course_users_remote

  get 'courses/:id/discuss'  => 'courses#show_discussion'       , as: :course_discussion


  get 'buckets/:id/content'  => 'buckets#show_content'          , as: :bucket_content
  post 'buckets/:id/content'  => 'buckets#show_content'          , as: :bucket_content_remote

  get 'buckets/:id/details'  => 'buckets#show_details'          , as: :bucket_details
  get 'buckets/:id/edit_details'  => 'buckets#edit_details'     , as: :edit_bucket_details
  post 'buckets/create'  => 'buckets#create_bucket'   , as: :create_bucket
  post 'buckets/:id'          => 'buckets#update_details'        , as: :update_bucket_details  
  get 'buckets/new/:course_id'  => 'buckets#new_bucket'          , as: :new_bucket
  delete 'buckets/:id'  => 'buckets#destroy_bucket'   , as: :destroy_bucket
  post '/buckets/:id/like',     to: 'buckets#up_vote'  , as: :like_bucket
  post '/buckets/:id/dislike',  to: 'buckets#down_vote', as: :dislike_bucket


  get 'folders/:id/content'       => 'folders#show_content'     , as: :folder_content
  post 'folders/:id/content'      => 'folders#show_content'     , as: :folder_content_remote

  get 'folders/:id/details'       => 'folders#show_details'     , as: :folder_details
  get 'folders/:id/edit_details'  => 'folders#edit_details'     , as: :edit_folder_details
  post 'folders/:id'               => 'folders#update_details'   , as: :update_folder_details  
  get 'folders/new/:parent_type/:parent_id'       => 'folders#new_folder'           , as: :new_folder
  post 'folders/create/:parent_type/:parent_id'   => 'folders#create_folder'        , as: :create_folder
  delete 'folders/:id'  => 'folders#destroy_folder'   , as: :destroy_folder

  get '/documents/:id/details'       => 'documents#show_details'         , as: :document_details
  get '/documents/:id/edit_details'  => 'documents#edit_details'         , as: :edit_document_details
  post '/documents/:id'             => 'documents#update_details'       , as: :update_document_details  
  get   '/documents/new'               => 'documents#new_document'         , as: :new_document
  post  '/documents/create/:parent_type/:parent_id' => 'documents#create_document'      , as: :create_document
  delete '/documents/:id'  => 'documents#destroy_document'   , as: :destroy_document
  get   '/documents/:id/view'               => 'documents#view_document'         , as: :view_document

  get '/my_uploads'             => 'user_details#uploads'                   , as: :uploads
  post '/my_uploads'             => 'user_details#uploads'                   , as: :uploads_remote

  get '/my_downloads'           => 'user_details#downloads'                 , as: :downloads
  post '/my_downloads'           => 'user_details#downloads'                 , as: :downloads_remote

  get '/profile_main'                => 'user_details#profile_main'                   , as: :profile_main
  get '/profile_uploads'                => 'user_details#profile_uploads'                , as: :profile_uploads
  get '/edit_profile'           => 'user_details#edit_profile'              , as: :edit_profile

  get '/enrolled_courses'       => 'user_details#enrolled_courses'          , as: :enrolled_courses
  post '/enrolled_courses'       => 'user_details#enrolled_courses'          , as: :enrolled_courses_remote

  get '/favorite_courses'       => 'user_details#favorite_courses'          , as: :favorite_courses
  post '/favorite_courses'       => 'user_details#favorite_courses'          , as: :favorite_courses_remote

  get '/my_college'             => 'user_details#my_college'                , as: :my_college


  get  '/enrollment'                  => 'user_details#new_college_branch_enrollment'           , as: :new_college_branch_enrollment
  post '/enrollment'                  => 'user_details#create_college_branch_enrollment'        , as: :create_college_branch_enrollment

  post '/unenrollment'                  => 'user_details#unenroll_college_branch_pair'        , as: :unenroll_college_branch_pair

  post '/favorite_course/:course_id'             => 'user_details#favorite_course'                         , as: :favorite_course
  post '/unfavorite_course/:course_id'           => 'user_details#unfavorite_course'                       , as: :unfavorite_course

  post '/enroll_course/:course_id'               => 'user_details#enroll_course'                , as: :enroll_course
  post '/unenroll_course/:course_id'             => 'user_details#unenroll_course'              , as: :unenroll_course

  post '/request_download_bucket/:bucket_id'  => 'user_details#request_download_bucket'         , as: :request_download_bucket
  post '/report/:bucket_id'                   => 'user_details#report_inappropriate'            , as: :report_inappropriate
  get '/download_bucket/:bucket_id'          => 'user_details#download_bucket'                 , as: :download_bucket
  get '/download_document/:document_id'          => 'user_details#download_document'           , as: :download_document
  post '/upload_bucket/:bucket_id'    => 'user_details#upload_bucket'                           , as: :upload_bucket
  post '/suggestion/:user_id'         => 'user_details#suggestion'                              , as: :suggestion



  get '/redirect_to_college'          => 'user_details#redirect_to_college'                     , as: :redirect_to_college
  
  post '/comments/create/:parent_type/:parent_id'            => 'comments#create_comment'                  , as: :create_comment
  post '/comment_responses/create/:comment_id'               => 'comments#create_comment_response'         , as: :create_comment_response


  get '/colleges/autocomplete_elements'   => "colleges#college_autocomplete_elements" , as: :get_college_autocompletion
  get '/branches/autocomplete_elements'   => "colleges#branch_autocomplete_elements" , as: :get_branch_autocompletion
  get '/courses/autocomplete_elements'    => "colleges#course_autocomplete_elements" , as: :get_course_autocompletion


  post '/search_buckets'     => "user_details#search_buckets" , as: :search_buckets 
  post '/search_courses'     => "user_details#search_courses" , as: :search_courses
  post '/search_users'       => "user_details#search_users" , as: :search_users

  post '/test_action' => "landings#test_action" , as: :test_action

  post '/refresh_download_buckets_notifications' => "landings#refresh_download_buckets_notifications" , as: :refresh_download_buckets_notifications
  post '/refresh_upload_documents_form' => "landings#refresh_upload_documents_form" , as: :refresh_upload_documents_form


  get '/'                       => 'landings#index'                         , as: :landing
  post '/'                       => 'landings#index'                         , as: :landing_remote

  Classcolab::Application.routes.draw do
    mount Resque::Server.new, at: "/resque"
  end
  
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
