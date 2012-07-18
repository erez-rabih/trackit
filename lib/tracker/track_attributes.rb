module Tracker
  module TrackAttributes
    extend ActiveSupport::Concern
 
    included do
    end
 
    module ClassMethods
      def track_attributes(*attrs)
        self.class_eval do
          before_save :update_tracked_attributes
          @tracked_attributes = attrs.flatten
        end
      end

      def tracked_attributes
        @tracked_attributes ||= []
      end
    end

    def update_tracked_attributes
      
    end

    def tracked
      @tracked ||= Tracker::Wrapper.new(self)
    end

  end

end
ActiveRecord::Base.send :include, Tracker::TrackAttributes
