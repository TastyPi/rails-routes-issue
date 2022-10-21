ENV["RAILS_ENV"] ||= "test" # This is important, changing it to development makes the test pass

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem "rails", github: "rails/rails", branch: "main"

  # Removing this causes an error:
  # RuntimeError: In order to use #url_for, you must include routing helpers explicitly. For instance, `include Rails.application.routes.url_helpers`.
  # Curiously that error is only thrown the second time root_path is accessed during the test, not the first
  gem "sprockets-rails"
end

require "rails"

module Bug
  class Engine < Rails::Engine
    isolate_namespace Bug

    # Defining the controller and routes in separate files makes a difference for some reason.
    config.root = File.join(__dir__, "bug_engine")

    # Doing this instead of having bug_engine/config/routes.rb causes bug.root_path to not be defined in the test
    # routes.draw do
    #   root "bug#bug"
    # end
  end

  # Doing this instead of having bug_engine/app/controllers/bug_controller.rb causes an error:
  # RuntimeError: In order to use #url_for, you must include routing helpers explicitly. For instance, `include Rails.application.routes.url_helpers`.
  # Curiously that error is only thrown the second time root_path is accessed during the test, not the first
  # class BugController < ActionController::Base
  #   def bug
  #     head 200
  #   end
  # end
end

module RouteIssue
  class Application < Rails::Application
    config.eager_load = false

    # Doing this instead of having config/routes.rb causes root_path to not be defined in the test
    # routes.draw do
    #   root "test#index"
    #   mount Bug::Engine, at: "/bug"
    # end
  end
end

Rails.application.initialize!

require "rails/test_help"

class BugTest < ActionDispatch::IntegrationTest
  test "root_paths are correct" do
    # These are correct
    assert_equal "/", root_path
    assert_equal "/bug/", bug.root_path

    # But then you do a request to an engine route
    get bug.root_path

    # And now this breaks
    assert_equal "/", root_path, "root_path is now returning /bug/ instead of /"
  end
end
