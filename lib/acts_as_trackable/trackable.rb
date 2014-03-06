module ActsAsTrackable
  module Trackable
    module Methods
      extend ActiveSupport::Concern

      self.included do
      end

      module ClassMethods
        def is_trackable?
          true
        end
      end # module ClassMethods

      def track_by?(tracker, action)
      # self.tracks.where(tracker: tracker, action: action).any?
        self.tracks.find_by(tracker: tracker, action: action).present?
      end

      def track_by(tracker, action, note = nil)
        self.tracks.create(tracker: tracker, action: action, note: note)
      end

      def untrack_by(tracker, action)
        self.tracks.where(tracker: tracker, action: action).destroy_all
      # if actions.nil?
      #   self.tracks.where(tracker: tracker).delete_all
      # else
      #   conditions = []
      #   actions.each do |act|
      #     conditions << "action = '#{act}'"
      #   end
      #   self.tracks.where(tracker: tracker).where(conditions.join(" or ")).destroy_all
      # end
      end
    end # module Methods
  end # module Trackable
end # module ActsAsTrackable
