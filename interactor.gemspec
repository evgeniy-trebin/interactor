# encoding: utf-8
# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name    = 'interactor'
  spec.version = '3.1.0'

  spec.author      = 'Collective Idea'
  spec.email       = 'info@collectiveidea.com'
  spec.description = 'Interactor provides a common interface for performing complex user interactions.'
  spec.summary     = 'Simple interactor implementation'
  spec.homepage    = 'https://github.com/collectiveidea/interactor'
  spec.license     = 'MIT'

  spec.files      = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.test_files = spec.files.grep(/^spec/)

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.3'
end
