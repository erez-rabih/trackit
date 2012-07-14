module Tracker
  module TrackAttributes
    extend ActiveSupport::Concern
 
    included do
    end
 
    module ClassMethods
      def track_attributes(attrs = [])
      end
    end
  end

end
ActiveRecord::Base.send :include, Tracker::TrackAttributes
