$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'datum/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'datum'
  s.version     = Datum::VERSION
  s.authors     = ['Syntax Engineering']
  s.email       = ['developers@syntaxindices.com']
  s.homepage    = 'https://github.com/syntax-engineering/datum'
  s.summary     = 'Flexible data-driven test solution for Rails'
  s.description = s.summary
  s.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  s.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/syntax-engineering'

  s.files = Dir["{app,config,db,lib}/**/*","MIT-LICENSE","Rakefile","README.md"]

  s.required_ruby_version = '>= 2.5.0'
  s.add_development_dependency 'database_cleaner'
  s.add_dependency 'minitest'
  s.add_dependency 'minitest-hooks'
  s.add_development_dependency 'rails'
end
