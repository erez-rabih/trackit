require 'rails/generators/active_record'
require 'rails/generators/migration'

module Tracker
  module Generators
    class TrackerGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      argument :attrs, :type => :array, :default => []

      def generate_track_attributes_call_on_model_file
        inject_into_class model_file_path,  model_class, model_content
      end

      def create_attributes_tracker_migration
        migration_template "migration.rb", "db/migrate/add_tracked_attributes_to_#{table_name}"
      end

      protected

      def model_file_path
        File.join("app", "models", "#{name.underscore}.rb")
      end

      def model_class
        name.camelize.constantize
      end

      def model_content
        "  track_attributes #{attrs.map {|a| ":#{a}"}.join(", ")}\n"
      end
    end
  end
end
