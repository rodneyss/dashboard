Rails.application.routes.draw do

  root :to => 'pages#home'

  get '/api/:query' => 'pages#api'

  get '/login' => 'session#new'
  post '/login' => 'session#create'
  delete '/login' => 'session#destroy'

end
