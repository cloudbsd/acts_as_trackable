require 'active_support'
require 'active_model'
require 'active_record'

require "acts_as_trackable/version"
require "acts_as_trackable/track"
require "acts_as_trackable/tracker"
require "acts_as_trackable/trackable"

module ActsAsTrackable
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def acts_as_trackable(options={})
      do_acts_as_trackable(options)
    end

    # action_trackers = :favorite_users
    #   names = favorite_users
    #   names[0] = favorite_users
    #   action_name = names[1] = 'favorite'
    #   names[2] = users
    #   action_tracks = favorite_tracks
    #   action_trackers_tracks = favorite_users_tracks
    def acts_as_trackable_by(action_trackers, options={})
      do_acts_as_trackable(options)

      if action_trackers.present?
        names = /(.+?)_(.+)/.match(action_trackers.to_s)
        action_name = names[1]
        object_type = names[2].singularize.camelize
        action_tracks = (action_name + '_tracks').to_sym
        action_tracker_tracks = (names[0] + '_tracks').to_sym

        has_many action_tracker_tracks, -> { where(action: action_name, tracker_type: object_type) }, as: :trackable, dependent: :destroy, class_name: 'ActsAsTrackable::Track'
        has_many action_tracks, -> { where(action: action_name) }, as: :trackable, dependent: :destroy, class_name: 'ActsAsTrackable::Track'
        has_many action_trackers, through: action_tracker_tracks, source: :tracker, source_type: object_type

        define_method("#{action_name}_by?") do |tracker|
          self.track_by?(tracker, action_name)
        end

        define_method("#{action_name}_by") do |tracker, note=nil|
          self.track_by(tracker, action_name, note)
        end

        define_method("un#{action_name}_by") do |tracker|
          self.untrack_by(tracker, action_name)
        end
      end
    end # acts_as_trackable_by

    def acts_as_tracker(options={})
      do_acts_as_tracker(options)
    end

    def acts_as_tracker_on(action_trackables, options={})
      do_acts_as_tracker(options)

      if action_trackables.present?
        names = /(.+?)_(.+)/.match(action_trackables.to_s)
        action_name = names[1]
        object_type = names[2].singularize.camelize
        action_tracks = (action_name + '_tracks').to_sym
        action_trackables_tracks = (names[0] + '_tracks').to_sym

        has_many action_trackables_tracks, -> { where(action: action_name, trackable_type: object_type) }, as: :tracker, dependent: :destroy, class_name: 'ActsAsTrackable::Track'
        has_many action_tracks, -> { where(action: action_name) }, as: :tracker, dependent: :destroy, class_name: 'ActsAsTrackable::Track'
        has_many action_trackables, through: action_trackables_tracks, source: :trackable, source_type: object_type

        define_method("#{action_name}?") do |trackable|
          self.track?(trackable, action_name)
        end

        define_method("#{action_name}") do |trackable, note=nil|
          self.track(trackable, action_name, note)
        end

        define_method("un#{action_name}") do |trackable|
          self.untrack(trackable, action_name)
        end
      end
    end # acts_as_tracker_on

    def do_acts_as_trackable(options={})
      unless self.is_trackable?
        has_many :tracks, {as: :trackable, dependent: :destroy, class_name: 'ActsAsTrackable::Track'}.merge(options)
        include ActsAsTrackable::Trackable::Methods
      end
    end

    def do_acts_as_tracker(options={})
      unless self.is_tracker?
        has_many :tracks, {as: :tracker, dependent: :destroy, class_name: 'ActsAsTrackable::Track'}.merge(options)
        include ActsAsTrackable::Tracker::Methods
      end
    end

    def is_trackable?
      false
    end

    def is_tracker?
      false
    end
  end # ClassMethods
end # ActsAsTrackable


ActiveRecord::Base.send :include, ActsAsTrackable
