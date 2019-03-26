Rails.application.routes.draw do
  resources :locations, except: :index
end
