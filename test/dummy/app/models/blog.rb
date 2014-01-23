class Blog < ActiveRecord::Base
  acts_as_trackable
  acts_as_trackable_by :favorite_users
end
