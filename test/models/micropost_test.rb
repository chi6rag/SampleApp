require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @micropost = Micropost.new(content: "Lorem Ipsum", user_id: @user.id)
  end

  # should be valid
  test "should be valid" do
    assert @micropost.valid?
  end

  # user_id should be present in every micropost
  # sets user id to nil and asserts that
  # a micropost with nil user id is not valid
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  # content should be present
  # sets the content attribute of micropost to be nil
  # and asserts that the corresponding micropost is invalid
  test "content should be present" do
    @micropost.content = nil
    assert_not @micropost.valid?
  end

  # content should be at most 140 characters
  # any micropost with content more than 140 characters
  # should not be valid
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
end
