$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "datum/version"
# s.add_development_dependency "pg"
# s.add_dependency "pg"
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

  s.add_dependency "rails", ">= 4.1.7"
  s.add_development_dependency "pg"

end
