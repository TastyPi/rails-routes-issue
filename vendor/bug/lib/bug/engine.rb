module Bug
  class Engine < Rails::Engine
    isolate_namespace Bug
  end
end
