require 'test_helper'

class ActsAsTrackableTest < ActiveSupport::TestCase
  setup do
    3.times do |i|
      User.create(name: "user#{i+1}")
    end
    3.times do |i|
      Blog.create(title: "blog title #{i+1}")
    end
    3.times do |i|
      Post.create(title: "post title #{i+1}")
    end
  end

  test "module 'ActsAsTrackable' is existed" do
    assert_kind_of Module, ActsAsTrackable
  end

  test "acts_as_tracker method is available" do
    assert User.respond_to? :acts_as_tracker
    assert User.respond_to? :acts_as_tracker_on
  end

  test "acts_as_trackable method is available" do
    assert Blog.respond_to? :acts_as_trackable
    assert Blog.respond_to? :acts_as_trackable_by
    assert Post.respond_to? :acts_as_trackable
    assert Post.respond_to? :acts_as_trackable_by
  end

  test "track?/track/untrack methods are available" do
    user = User.first
    assert user.respond_to? :track?
    assert user.respond_to? :track
    assert user.respond_to? :untrack
  end

  test "method 'acts_as_tracker' is available" do
    user1, user2 = User.all[0], User.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal(false, user1.track?(post1, 'favorite'))
    user1.track(post1, 'favorite')
    assert_equal(true, user1.track?(post1, 'favorite'))
    assert_equal 1, ActsAsTrackable::Track.all.count
    assert_equal 1, user1.tracks.count

    user1.track(post2, 'favorite')
    assert_equal(true, user1.track?(post2, 'favorite'))
    assert_equal 2, user1.tracks.count

    user1.track(post2, 'read')
    assert(user1.track?(post2, 'read'))
    assert_equal 3, user1.tracks.count
    assert_equal 2, user1.tracks.where(action: 'favorite').count
    assert_equal 1, user1.tracks.where(action: 'read').count

    user1.untrack(post2, 'read')
    assert(!user1.track?(post2, 'read'))
    assert_equal 2, user1.tracks.count

    user1.untrack(post2, 'favorite')
    assert_equal(false, user1.track?(post2, 'favorite'))
    assert_equal 1, user1.tracks.count

    user1.untrack(post1, 'favorite')
    assert_equal(false, user1.track?(post1, 'favorite'))
    assert_equal 0, user1.tracks.count
  end

  test "method 'acts_as_tracker_on' is available" do
    user1, user2 = User.all[0], User.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal 0, user1.favorite_posts_tracks.count
    assert_equal 0, user1.favorite_posts.count
    user1.track(post1, 'favorite')
    assert_equal 1, user1.tracks.where(action: 'favorite').size
    assert_equal 1, user1.favorite_posts_tracks.count
    assert_equal 1, user1.favorite_posts.count

    assert_equal 0, user1.read_posts_tracks.count
    assert_equal 0, user1.read_posts.count
    user1.track(post1, 'read')
    assert_equal 1, user1.tracks.where(action: 'read').size
    assert_equal 1, user1.read_posts_tracks.count
    assert_equal 1, user1.read_posts.count

    assert_equal 2, user1.tracks.size
  end

  test "method 'acts_as_trackable_by' is available" do
    user1, user2 = User.all[0], User.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal 0, post1.favorite_users_tracks.count
    assert_equal 0, post1.favorite_users.count
    user1.track(post1, 'favorite')
    assert_equal 1, post1.tracks.where(action: 'favorite').size
    assert_equal 1, post1.favorite_users_tracks.count
    assert_equal 1, post1.favorite_users.count

    assert_equal 0, post1.read_users_tracks.count
    assert_equal 0, post1.read_users.count
    user1.track(post1, 'read')
    assert_equal 1, post1.tracks.where(action: 'read').size
    assert_equal 1, post1.read_users_tracks.count
    assert_equal 1, post1.read_users.count

    assert_equal 2, post1.tracks.size
  end

  test "generated methods by 'acts_as_tracker_on' are available" do
    user1, user2 = User.all[0], User.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal 0, user1.favorite_posts_tracks.count
    assert_equal 0, user1.favorite_posts.count

    assert_equal false, user1.favorite?(post1)
    user1.favorite(post1)
    assert_equal true, user1.favorite?(post1)

    user1.favorite(post2)
    assert_equal 2, user1.tracks.where(action: 'favorite').size
    assert_equal 2, user1.favorite_posts_tracks.count
    assert_equal 2, user1.favorite_posts.count

    user1.unfavorite(post2)
    assert_equal 1, user1.tracks.where(action: 'favorite').size
    assert_equal 1, user1.favorite_posts_tracks.count
    assert_equal 1, user1.favorite_posts.count

    assert_equal 0, user1.read_posts_tracks.count
    assert_equal 0, user1.read_posts.count

    user1.read(post1)
    assert_equal 1, user1.tracks.where(action: 'read').size
    assert_equal 1, user1.read_posts_tracks.count
    assert_equal 1, user1.read_posts.count

    assert_equal 2, user1.tracks.size
  end

  test "generated methods 'acts_as_trackable_by' are available" do
    user1, user2 = User.all[0], User.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal 0, post1.favorite_users_tracks.count
    assert_equal 0, post1.favorite_users.count

    assert_equal false, post1.favorite_by?(user1)
    post1.favorite_by user1
    assert_equal true, post1.favorite_by?(user1)

    assert_equal 1, post1.tracks.where(action: 'favorite').size
    assert_equal 1, post1.favorite_users_tracks.count
    assert_equal 1, post1.favorite_users.count

    post1.unfavorite_by user1
    assert_equal false, post1.favorite_by?(user1)

    assert_equal 0, post1.read_users_tracks.count
    assert_equal 0, post1.read_users.count
    user1.track(post1, 'read')
    assert_equal 1, post1.tracks.where(action: 'read').size
    assert_equal 1, post1.read_users_tracks.count
    assert_equal 1, post1.read_users.count

    assert_equal 1, post1.tracks.size
  end

  test "using same action for blog and post works" do
    user1, user2 = User.all[0], User.all[1];
    blog1, blog2 = Blog.all[0], Blog.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal 0, user1.favorite_posts_tracks.count
    assert_equal 0, user1.favorite_posts.count

    assert_equal false, user1.favorite?(blog1)
    assert_equal false, user1.favorite?(post1)
    user1.favorite(blog1)
    user1.favorite(post1)
    assert_equal true, user1.favorite?(blog1)
    assert_equal true, user1.favorite?(post1)

    assert_equal 2, user1.tracks.size
    assert_equal 2, user1.tracks.where(action: 'favorite').size
    assert_equal 2, user1.favorite_tracks.count
    assert_equal 1, user1.favorite_blogs_tracks.count
    assert_equal 1, user1.favorite_blogs.count
    assert_equal 1, user1.favorite_posts_tracks.count
    assert_equal 1, user1.favorite_posts.count
  end
end
