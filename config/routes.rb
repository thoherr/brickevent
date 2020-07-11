BrickEvent::Application.routes.draw do
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

  devise_for :users

  resources :accommodations
  resources :attendances do
    member do
      post 'copy_exhibits/:other_attendance_id', :action => :copy_exhibits, :as => :copy_exhibits
      post 'add_former_exhibit/:former_exhibit_id', :action => :add_former_exhibit, :as => :add_former_exhibit
      post 'approve', :action => :approve, :as => :approve
      get 'former_exhibits'
    end
  end
  resources :attendees do
    member do
      post 'approve', :action => :approve, :as => :approve
    end
  end
  resources :events
  resources :exhibits do
    member do
      post 'approve', :action => :approve, :as => :approve
    end
  end
  resources :users

  # special data export routes
  get 'events/:id/attendees_as_csv' => 'events#attendees_as_csv'
  get 'events/:id/exhibits_as_csv' => 'events#exhibits_as_csv'

  resources :accommodation_types
  resources :attendee_types

  namespace :admin do
    resources :accommodations do as_routes end
    resources :attendances do as_routes end
    resources :attendees do as_routes end
    resources :events do as_routes end
    resources :event_managers do as_routes end
    resources :exhibits do as_routes end
    resources :lugs do as_routes end
    resources :users do as_routes end
    resources :accommodation_types do as_routes end
    resources :attendee_types do as_routes end
  end

  root :to => "events#index"

end
