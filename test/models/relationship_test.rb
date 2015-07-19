# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: 1, followed_id: 2)
  end

  # returns if a given relationship is valid
  test "should be valid" do
    assert @relationship.valid?
  end

  # should require follower id
  # should not allow relationships with nil follower id
  test "should require follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid? # should fail if the followed_id is nil
  end

  # should require followed_id
  # should not allow relationships with nil followed id
  test "should require followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid? # should fail if the followed_id is nil
  end
end
