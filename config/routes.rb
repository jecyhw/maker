Rails.application.routes.draw do

  root to: redirect('/maker/index')
  get 'maker', to: redirect('/maker/index')
  scope :maker do
    match 'index' => 'maker#index', :via => :all, :as => :maker_index
    scope :user do
      match :student, :to => 'student#index', :via => [:post, :get], as: :maker_user_student
      resources :canteen_worker, only: [:index], as: :maker_user_canteen_worker
      match 'admin', :to => 'admin#index', :via => [:post, :get], :as => :maker_user_admin
      match 'login', :to => 'user#login', :via => [:post, :get], :as => :maker_user_login
      match 'register', :to => 'user#register', :via => [:get, :post], :as => :maker_user_register
      match 'logout', :to => 'user#logout', :via => :get, :as => :maker_user_logout
      # match 'activation', :to => 'user#activation', :via => :get, :as => :maker_user_activation
      match 'password_reset', :to => 'user#password_reset', :via => [:get, :post], :as => :maker_user_password_reset
    end
    match '*unmatched_route', :to => 'application#invalid_page', :via => :all
  end

  # match 'test' => 'maker#test_same', :via => :get
  # match 'test' => 'maker#test_same', :via => :post
  #
  # match 'test' => 'maker#test_df1', :via => :get
  # match 'test' => 'maker#test_df2', :via => :post
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
