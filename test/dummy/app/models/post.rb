class Post < ActiveRecord::Base
  acts_as_trackable
  acts_as_trackable_by :favorite_users
  acts_as_trackable_by :read_users
end
