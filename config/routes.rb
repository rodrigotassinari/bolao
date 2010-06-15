ActionController::Routing::Routes.draw do |map|
  map.devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'register' }
  
  map.resources :users,
    :member => {:ask_to_bet => :post, :ask_for_payment => :post}
  
  map.resource :my_bet
  
  map.resources :bets
  
  map.resources :bonus_bets

  map.resources :games do |game_map|
    game_map.resources :comments, :controller => 'game_comments'
  end

  map.resources :bonus

  map.resources :teams
  
  map.resource :payment, :member => {:done => :any}
  
  map.rules 'rules', :controller => 'pages', :action => 'rules'

  map.invite 'invite', :controller => 'pages', :action => 'invite'

  map.root :controller => "pages", :action => "index"
  
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
