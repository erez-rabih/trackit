$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "trackit/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "trackit"
  s.version     = TrackIt::VERSION
  s.authors     = ["Erez Rabih"]
  s.email       = ["erez.rabih@gmail.com"]
  s.homepage    = "https://github.com/erez-rabih/tracker"
  s.summary     = "TrackIt allows you to track attributes changes in your ActiveRecord models"
  s.description = "TrackIt allows you to track attributes changes in your ActiveRecord models"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.6"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-spork"
  s.add_development_dependency "growl"
  s.add_development_dependency "debugger"
end
