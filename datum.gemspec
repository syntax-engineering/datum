
$:.push File.expand_path("../lib", __FILE__)
require "datum/version"

Gem::Specification.new do |s|
  s.name        = "datum"
  s.version     = Datum::VERSION
  s.authors     = ["Tyemill", "Gabriel Marius"]
  s.email       = ["datum@tyemill.com"]
  s.homepage    = "https://github.com/tyemill/datum"
  s.summary     = "Flexible data-driven test solution for Rails"
  s.description = s.summary

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.1"
end