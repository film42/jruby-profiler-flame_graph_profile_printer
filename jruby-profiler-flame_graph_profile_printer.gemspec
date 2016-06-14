# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jruby/profiler/flame_graph_profile_printer'

Gem::Specification.new do |spec|
  spec.name          = "jruby-profiler-flame_graph_profile_printer"
  spec.version       = JRuby::Profiler::FlameGraphProfilePrinter::VERSION
  spec.authors       = ["Garrett Thornburg"]
  spec.email         = ["film42@gmail.com"]

  spec.summary       = "FlameGraph profiler for JRuby"
  spec.description   = "FlameGraph profiler for JRuby"
  spec.homepage      = "https://github.com/film42/jruby-profiler-flame_graph_profile_printer"
  spec.license       = "MIT"

  spec.platform      = "java"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
