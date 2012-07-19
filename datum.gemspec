$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "datum/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "datum"
  s.version     = Datum::VERSION
  s.authors     = ["Tyemill"]
  s.email       = ["datum@tyemill.com"]
  s.homepage    = "http://www.tyemill.com/datum"
  s.summary     = "TODO: Summary of Datum."
  s.description = "TODO: Description of Datum."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.1"

  s.add_development_dependency "sqlite3"
end
