Rails.application.routes.draw do
  root "app#index"
  mount Bug::Engine, at: "/bug"
end
