Cheval::Application.routes.draw do
  resources :twitter_tags


  resources :food_sliders


devise_for :admins, :controllers => {:registrations => "registrations"}, :skip => [:registrations]
as :admin do
  get 'admins/edit' => 'devise/registrations#edit', :as => 'edit_admin_registration'
  put 'admins' => 'devise/registrations#update', :as => 'admin_registration'
end

  match "/about" => "static#about", as: :about
  match "/menu" => "static#menu", as: :menu
  match "/photos" => "static#photos", as: :photos
  match "/art_club" => "static#art_club", as: :art_club
  match "/press" => "static#press", as: :press
  match "/contact" => "static#contact", as: :contact
  match "/upcoming_events" => "static#upcoming_events", as: :upcoming_events
  match "/past_events" => "static#past_events", as: :past_events
  match "/show_event/:id" => "static#show_event", as: :show_event

  scope "/admin" do
    root to: "events#index"
    resources :events
    resources :slider_images  
    resources :special_menus
    resources :press_links
    resources :print_media
  end

  root to: "static#index"
end