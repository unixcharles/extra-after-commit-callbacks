Gem::Specification.new do |spec|
  spec.name        = 'extra-after-commit-callbacks'
  spec.version     = '0.1.0'
  spec.summary     = 'Fine grained after_commit callbacks for ActiveRecord observers'
  spec.author      = 'Charles Barbier'
  spec.email       = 'unixcharles@gmail.com'
  spec.homepage    = 'http://github.com/unixcharles/extra-after-commit-callbacks'

  spec.files        = Dir['README.md', 'LICENSE', 'lib/**/*']
  spec.require_path = 'lib'

  spec.add_dependency('activerecord', '>= 3.0.0')
  spec.add_dependency('activesupport', '>= 3.0.0')

  spec.add_development_dependency('appraisal')
  spec.add_development_dependency('rspec', '>= 2.0.0')
  spec.add_development_dependency('sqlite3')
end
