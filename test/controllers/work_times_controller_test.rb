require "test_helper"

class WorkTimesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get work_times_new_url
    assert_response :success
  end

  test "should get create" do
    get work_times_create_url
    assert_response :success
  end
end
