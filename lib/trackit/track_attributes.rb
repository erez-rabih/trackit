module TrackIt
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
      changed_attrs = self.changes.keys.map(&:to_sym)
      changed_tracked_attributes = self.class.tracked_attributes.select {|k| changed_attrs.include?(k)}
      changed_tracked_attributes.each do |attr|
        self.tracked.set_changed(attr)
      end
    end

    def tracked
      @tracked ||= TrackIt::Wrapper.new(self)
    end

  end

end
ActiveRecord::Base.send :include, TrackIt::TrackAttributes
