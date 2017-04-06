Rails.application.routes.draw do
  root 'welcome#index'

  get 'auth/:provider/callback' => 'sessions#create'
  get 'signout'                 => 'sessions#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
