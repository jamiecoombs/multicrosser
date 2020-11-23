Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  root 'init#index'

  get 'crossword/:room(/:participant)', to: 'page#index', as: 'page'
  get 'crossword/:room/:source/:series/:identifier/:participant', to: 'crossword#show', as: 'crossword'
  #get 'crossword/:room/:source/:series/:identifier/:participant', to: 'rooms#show', as: 'room'
  #get 'crossword/:source/:series/:identifier/:participant', to: 'crosswords#show', as: 'crossword'
  #get 'crossword/:source/:series/:identifier', to: 'crosswords#show', as: 'crossword'
end
