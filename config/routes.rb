Rails.application.routes.draw do

  match "/assignments/search_by_name", to: "assignments#search_by_name", via: :get
  match "/assignments/name_results", to: "assignments#name_results", via: :post
  match "/assignments/new_single", to: "assignments#new_single_assignment_get", via: :get
  match "/assignments/new_single_create", to: "assignments#new_single_assignment_create", via: :post

  match "submissions/:id/delete_attachment", to: "submissions#delete_attachment", via: :post
  resources :submissions
  resources :assignments

  match "/users/list", to: "users#list", via: :get
  match "/users/student_review", to: "users#student_review", via: :get
  devise_for :users, controllers: {registrations: "registrations"}
  resources :users

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'users#index'

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
end
