Rails.application.routes.draw do
  root 'page#index'

  get 'crossword/:source/:series/:identifier/:participant/:room', to: 'rooms#show', as: 'room'
  get 'crossword/:source/:series/:identifier/:participant', to: 'crosswords#show', as: 'crossword'
end
