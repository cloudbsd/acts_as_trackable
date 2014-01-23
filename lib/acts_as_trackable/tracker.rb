module ActsAsTrackable
  module Tracker
    module Methods
      extend ActiveSupport::Concern

      self.included do
      end

      module ClassMethods
        def is_tracker?
          true
        end
      end # module ClassMethods

      def track?(trackable, action = nil)
      # self.tracks.where(trackable: trackable, action: action).any?
        self.tracks.find_by(trackable: trackable, action: action).present?
      end

      def track(trackable, action = nil)
        self.tracks.create(trackable: trackable, action: action)
      end

      def untrack(trackable, action = nil)
        self.tracks.where(trackable: trackable, action: action).destroy_all
      end
    end # module Methods
  end # module Tracker
end # module ActsAsTrackable
