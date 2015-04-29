$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rollenspiel/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rollenspiel"
  s.version     = Rollenspiel::VERSION
  s.authors     = ["Jens Bissinger"]
  s.email       = ["mail@jens-bissinger.de"]
  s.homepage    = "https://github.com/bsingr/rollenspiel"
  s.summary     = "Role management for Rails 4.2 / ActiveRecord. Supports scoping and inheritance."
  s.description = "Role management for Rails 4.2 / ActiveRecord. Supports scoping and inheritance."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "sqlite3"
end
