Rails.application.routes.draw do

  concern :active_scaffold_association, ActiveScaffold::Routing::Association.new
  concern :active_scaffold, ActiveScaffold::Routing::Basic.new(association: true)

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
    collection do
      post :position_import
    end
    member do
      post 'approve', :action => :approve, :as => :approve
      get 'voting_poster', :action => :voting_poster, :as => :voting_poster
      resources :votes, :only => [:new, :create]
    end
  end
  resources :users

  # special data export routes
  post 'events/:id/attendees_as_csv' => 'events#attendees_as_csv'
  post 'events/:id/exhibits_as_csv' => 'events#exhibits_as_csv'

  resources :accommodation_types
  resources :attendee_types

  namespace :admin do
    resources :accommodations, concerns: :active_scaffold
    resources :attendances, concerns: :active_scaffold
    resources :attendees, concerns: :active_scaffold
    resources :events, concerns: :active_scaffold
    resources :event_managers, concerns: :active_scaffold
    resources :exhibits, concerns: :active_scaffold
    resources :lugs, concerns: :active_scaffold
    resources :users, concerns: :active_scaffold
    resources :accommodation_types, concerns: :active_scaffold
    resources :attendee_types, concerns: :active_scaffold
    resources :units, concerns: :active_scaffold
  end

  root :to => "events#index"

end
