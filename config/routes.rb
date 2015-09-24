Rails.application.routes.draw do
  
root :to => 'pages#home'

get '/api/:query' => 'pages#api'

end
