require 'rails/generators/active_record'

class AttributesTrackerGenerator < Rails::Generators::NamedBase
  include ActiveSupport::Inflector
  source_root File.expand_path('../templates', __FILE__)
  argument :attrs, :type => :array, :default => []

  def generate_track_attributes_call_on_model_file
    inject_into_class "app/models/#{name.underscore}.rb", name.camelize.constantize , "  track_attributes #{attrs.map {|a| ":#{a}"}.join(", ")}\n"
  end

  def create_attributes_tracker_migration

  end
end
