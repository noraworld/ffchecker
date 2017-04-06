Rails.application.routes.draw do
  root 'welcome#index'

  get 'signin'                  => redirect('/auth/twitter')
  get 'auth/:provider/callback' => 'sessions#create'
  get 'signout'                 => 'sessions#destroy'

  get 'followings/page/:num'    => 'followings#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
