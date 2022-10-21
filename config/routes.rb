Rails.application.routes.draw do
  root "test#index"
  mount Bug::Engine, at: "/bug"
end
