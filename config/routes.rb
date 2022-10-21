Rails.application.routes.draw do
  get "/test", to: "test#test"
  mount Bug::Engine, at: "/bug"
end
