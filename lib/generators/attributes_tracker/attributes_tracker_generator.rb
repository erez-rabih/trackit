class AttributesTrackerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  argument :attrs, :type => :array, :default => []

  def generate_track_attributes_call_on_model_file
    inject_into_class "app/models/#{name}.rb", name.constantize , "track_attributes"
  end
end
