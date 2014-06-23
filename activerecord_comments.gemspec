# coding: utf-8
require File.expand_path('../lib/activerecord_comments/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'activerecord_comments'
  spec.version       = ActiveRecord::Comments::VERSION
  spec.authors       = ['Marton Somogyi']
  spec.email         = ['msomogyi@whitepages.com']
  spec.summary       = %q{Comments for SQL schemas}
  spec.description   = %q{Manage comments for SQL tables and columns}
  spec.homepage      = 'https://github.com/mcbuddha/activerecord_comments'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10'
  spec.add_development_dependency 'rspec', '~> 3'

  spec.add_development_dependency 'pg', '~> 0.17'
  spec.add_development_dependency 'mysql2', '~> 0'
  spec.add_development_dependency 'sqlite3', '~> 0'

  spec.add_runtime_dependency 'activerecord', '~> 3'
end
