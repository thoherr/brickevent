BrickEvent::Application.routes.draw do

  devise_for :users

  resources :accommodations
  resources :attendances do
    member do
      post 'copy_exhibits/:other_attendance_id', :action => :copy_exhibits, :as => :copy_exhibits
    end
  end
  resources :attendees
  resources :events
  resources :exhibits
  resources :users

  # special data export routes
  match 'events/:id/export_attendees_csv' => 'events#export_attendees_csv'
  match 'events/:id/export_exhibits_csv' => 'events#export_exhibits_csv'

  resources :accommodation_types
  resources :attendee_types

  namespace :admin do
    resources :accommodations do as_routes end
    resources :attendances do as_routes end
    resources :attendees do as_routes end
    resources :events do as_routes end
    resources :exhibits do as_routes end
    resources :users do as_routes end
    resources :accommodation_types do as_routes end
    resources :attendee_types do as_routes end
  end

  root :to => "events#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
