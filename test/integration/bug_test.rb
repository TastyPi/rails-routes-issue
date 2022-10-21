require "test_helper"

class BugTest < ActionDispatch::IntegrationTest
  test "root_paths are correct" do
    # These are correct
    assert_equal "/", root_path
    assert_equal "/bug/", bug.root_path

    # But then you do a request to an engine route
    get bug.root_path

    # And now this breaks
    assert_equal "/", root_path, "root_path has changed to /bug/"
  end
end
