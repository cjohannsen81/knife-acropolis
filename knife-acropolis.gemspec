# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'knife-acropolis/version'

Gem::Specification.new do |s|
  s.name        = 'knife-acropolis'
  s.version     = Knife::Acropolis::VERSION
  s.platform    = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.md', 'LICENSE']
  s.authors     = ['Christian Johannsen']
  s.email       = ['c.johannsen@clickedways.de']
  s.homepage    = 'https://github.com/cjohannsen81/knife-acropolis'
  s.summary     = 'Nutanix Acropolis plugin'
  s.description = 'Knife plugin for Nutanix Acropolis.'
  s.license     = 'APAFML'
  s.files	= Dir.glob('{lib}/**/*') + %w(LICENSE README.md CHANGELOG.md)
  s.require_paths = ['lib']

  s.add_dependency 'chef', '~> 12.0'
  s.add_dependency 'rest-client', '~> 1.8'
  s.add_dependency 'json', '~> 1.7'
end
