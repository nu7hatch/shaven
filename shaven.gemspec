# -*- ruby -*-
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'shaven/version'

Gem::Specification.new do |s|
  s.name              = "shaven"
  s.rubyforge_project = "shaven"
  s.version           = Shaven::VERSION
  s.authors           = ["Chris Kowalik"]
  s.email             = ["chris@nu7hat.ch"]
  s.homepage          = "http://github.com/nu7hatch/shaven"
  s.summary           = "Shaven - templating without mustaches!"
  s.description       = "Shaven is templating system for logic less, and extra markup free templates."

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths     = ['lib']

  s.add_dependency 'nokogiri', '~> 1.4'
end
