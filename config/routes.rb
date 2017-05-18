Rails.application.routes.draw do

  root 'index#index'

  get    'signin'                  => redirect('/auth/twitter')
  get    'auth/:provider/callback' => 'sessions#create'
  get    'signout'                 => 'sessions#destroy'

  get    'followings'              => 'followings#index'
  get    'followings/page/:num'    => 'followings#index'

  get    'followers'               => 'followers#index'
  get    'followers/page/:num'     => 'followers#index'

  get    'lists'                   => 'lists#index'
  get    'lists/:listname'         => 'lists#show'

  post   'follow/:username'        => 'actions#create'
  delete 'unfollow/:username'      => 'actions#destroy'

  # post   'mute/:username'
  # delete 'unmute/:username'

  # post   'block/:username'
  # delete 'unblock/:username'

  # post   'lists/move/:username/:listname_src/to/:listname_dest'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
