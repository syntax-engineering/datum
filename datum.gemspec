$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "datum/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "datum"
  s.version     = Datum::VERSION
  s.authors     = ["Tyemill"]
  s.email       = ["datum@tyemill.com"]
  s.homepage    = "https://github.com/tyemill/datum"
  s.summary     = "Flexible data-driven test solution for Rails"
  s.description = s.summary
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*","MIT-LICENSE","Rakefile","README.md"]

  s.add_dependency "minitest"
  s.add_dependency 'minitest-hooks'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'database_cleaner'
end
