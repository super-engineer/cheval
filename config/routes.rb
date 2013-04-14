Cheval::Application.routes.draw do
  devise_for :admins

  match "/about" => "static#about", as: :about
  match "/menu" => "static#menu", as: :menu
  match "/photos" => "static#photos", as: :photos
  match "/art_club" => "static#art_club", as: :art_club
  match "/press" => "static#press", as: :press
  match "/contact" => "static#contact", as: :contact
  match "/upcoming_events" => "static#upcoming_events", as: :upcoming_events
  match "/past_events" => "static#past_events", as: :past_events
  match "/show_event/:id" => "static#show_event", as: :show_event
  root to: "static#index"

  scope "/admin" do
    root to: "static#index"
    resources :events
    resources :slider_images  
    resources :special_menus
    resources :press_links
  end
end