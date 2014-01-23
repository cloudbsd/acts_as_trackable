class User < ActiveRecord::Base
  acts_as_tracker
  acts_as_tracker_on :favorite_blogs
  acts_as_tracker_on :favorite_posts
  acts_as_tracker_on :read_posts
end
