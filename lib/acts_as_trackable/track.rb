module ActsAsTrackable
  class Track < ActiveRecord::Base
    belongs_to :trackable, :polymorphic => true
    belongs_to :tracker, :polymorphic => true

    validates :trackable, presence: true
    validates :tracker, presence: true
    validates :action, presence: true
  end
end
